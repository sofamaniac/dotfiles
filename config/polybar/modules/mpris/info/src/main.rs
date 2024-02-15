use std::{collections::HashMap, io::Read, time::Duration, vec};

use futures_util::stream::StreamExt;
use unicode_segmentation::UnicodeSegmentation;
use unicode_width::UnicodeWidthStr;
use zbus::{dbus_proxy, Connection};

#[dbus_proxy(
    interface = "org.mpris.MediaPlayer2.Player",
    default_path = "/org/mpris/MediaPlayer2"
)]
trait Player {
    /// Metadata property
    #[dbus_proxy(property)]
    fn metadata(&self) -> zbus::Result<HashMap<String, zbus::zvariant::OwnedValue>>;
}

fn string_len(string: &str) -> usize {
    UnicodeWidthStr::width_cjk(string)
}

/// Pad `string` to the right by adding non-breaking space
/// until either `string` has length `lenght`
/// or `limit` spaces have been added
fn pad_right(string: &mut String, length: usize, limit: usize) {
    let mut spaces = 0;
    while string_len(string) < length && spaces < limit {
        string.push('\u{00A0}'); // Non-breaking space
        spaces += 1;
    }
}

fn split<'a>(chars: &'a [&'a str], limit: usize) -> Vec<String> {
    let title = chars.join("");
    let mut res = Vec::new();
    if string_len(&title) <= limit {
        res.push(title);
        return res;
    };
    let mut start = 0; // index of start of current chunk
    while start < chars.len() + limit / 2 {
        // we have to use `chars` instead of `title` because `title[start..end]`
        // return a slice on the *bytes* of `title` which may not be a valide utf-8 string
        let mut index = start;
        while index < chars.len() && string_len(&chars[start..index].join("")) < limit {
            index += 1;
        }
        index = index.min(chars.len() - 1);
        let chunk_start = start.min(index);
        let mut chunk = chars[chunk_start..index].join("");
        if string_len(&chunk) > limit {
            // remove the last character
            chunk.pop();
        }
        // A chunk looks something like `Titletitle    { spaces }     Titletitle`
        // with the blank space measuring `limit / 2`
        pad_right(&mut chunk, limit, limit / 2 + chars.len() - start);
        for c in chars {
            chunk.push_str(c);
            if string_len(&chunk) >= limit {
                chunk.pop();
                break;
            }
        }
        pad_right(&mut chunk, limit, limit / 2 + chars.len() - start);
        start += 1;
        res.push(chunk);
    }
    res
}

fn get_player() -> String {
    let mut file = match std::fs::File::open("/var/tmp/player_selector") {
        Ok(f) => f,
        Err(_) => return "whatever".to_string(),
    };

    let mut player = String::new();
    match file.read_to_string(&mut player) {
        Ok(_) => player.trim().to_string(),
        Err(_) => "whatever".to_string(),
    }
}

const LIMIT: usize = 20;
const SHIFT_DELAY: u64 = 500;
const INIT_DELAY: u64 = 5; // INIT_DELAY * SHIFT_DELAY ms to wait before starting scrolling

#[tokio::main]
async fn main() -> std::result::Result<(), Box<dyn std::error::Error>> {
    let connection = Connection::session().await?;
    let mut player = get_player();
    let mut proxy = PlayerProxy::builder(&connection)
        .destination(format!("org.mpris.MediaPlayer2.{}", player))?
        .build()
        .await?;
    let mut stream = proxy.receive_metadata_changed().await;
    let mut chunks: Vec<String> = vec![];
    let mut index = 0;
    let mut wait = 2;
    loop {
        while let Ok(Some(v)) =
            tokio::time::timeout(Duration::from_millis(SHIFT_DELAY), stream.next()).await
        {
            let data = v.get().await?;
            let title: &str = match data.get("xesam:title") {
                Some(t) => t.downcast_ref().unwrap(),
                None => continue,
            };
            let chars = UnicodeSegmentation::graphemes(title, true).collect::<Vec<&str>>();
            chunks = split(&chars, LIMIT);
            index = 0;
            wait = INIT_DELAY;
        }
        if index < chunks.len() {
            println!("{}", chunks[index]);
        }
        if wait == 0 {
            index += 1;
        } else {
            wait -= 1;
        }
        let player2 = get_player();
        if index >= chunks.len() || player2 != player {
            index = 0;
            wait = INIT_DELAY;
        }
        if player2 != player {
            player = player2;
            proxy = PlayerProxy::builder(&connection)
                .destination(format!("org.mpris.MediaPlayer2.{}", player))?
                .build()
                .await?;
            stream = proxy.receive_metadata_changed().await;
        }
    }
}
