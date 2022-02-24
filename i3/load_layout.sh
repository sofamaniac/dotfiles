#!/bin/bash

# we append the layouts to the current layout

i3-msg "workspace 1; append_layout ~/.config/i3/workspace-1.json"
i3-msg "workspace 2; append_layout ~/.config/i3/workspace-2.json"
i3-msg "workspace 3; append_layout ~/.config/i3/workspace-3.json"

# then we start the applications
(/usr/bin/firefox &)
(/usr/bin/discord &)
(/usr/bin/element-desktop &)
(/usr/bin/thunderbird &)
(kitty &)
