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

fn split<'a>(chars: &'a [&'a str], limit: usize) -> Vec<Vec<&'a str>> {
    let mut res = vec![];
    let mut start = 0;
    let title = chars.join("");
    if UnicodeWidthStr::width(title.as_str()) <= limit {
        res.push(chars.to_vec());
        return res;
    }
    while start < chars.len() + limit / 2 {
        let mut chunk = vec![];
        let mut size = 0;
        let mut index = start;
        while index < chars.len() {
            let width = UnicodeWidthStr::width(chars[index]);
            if size + width > limit {
                break;
            }
            chunk.push(chars[index]);
            index += 1;
            size += width;
        }
        let mut spaces = 0;
        while size < limit && spaces + start < limit / 2 + chars.len() {
            chunk.push("\u{00A0}");
            size += 1;
            spaces += 1;
        }
        let mut index2 = 0;
        while size < limit {
            let width = UnicodeWidthStr::width(chars[index2]);
            if size + width > limit {
                break;
            }
            chunk.push(chars[index2]);
            index2 += 1;
            size += width;
        }
        let mut spaces = 0;
        while size < limit && spaces < limit / 2 {
            chunk.push("\u{00A0}"); // Non-breaking space
            size += 1;
            spaces += 1;
        }
        start += 1;
        res.push(chunk);
    }
    res
}

fn get_player() -> String {
    let mut file = match std::fs::File::open("/var/tmp/player_selector") {
        Ok(f) => f,
        Err(_) => return "".to_string(),
    };

    let mut player = String::new();
    match file.read_to_string(&mut player) {
        Ok(_) => player.trim().to_string(),
        Err(_) => "".to_string(),
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
            let tmp_chunks = split(&chars, LIMIT);
            chunks = tmp_chunks.into_iter().map(|c| c.join("")).collect();
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
