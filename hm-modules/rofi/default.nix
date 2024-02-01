{ pkgs, config,  ... }:

{
    programs.rofi = {
	enable = true;
	package = pkgs.rofi-wayland;
	extraConfig = {
	    show-icons = true;
	    drun-display-format = "{name}";
	};
	theme = let inherit (config.lib.formats.rasi) mkLiteral; in {
	    "*" = {
		font = "SF Pro 16";
		background = mkLiteral "#1E2127FF";
		background-alt = mkLiteral "#282B31FF";
		selected = mkLiteral "#61AFEFFF";
		foreground = mkLiteral "#FFFFFFFF";

	    };
	    "window" = {
		transparency = "real";
		location = "center";
		anchor = "center";
		fullscreen = "true";
		width = "1366px";
		height = "768px";
		x-offset = "0px";
		y-offset = "0px";
		enabled = "true";
		margin = "0px";
		padding = "0px";
		border = mkLiteral "0px solid";
		border-radius = "0px";
		border-color = "@selected";
		background-color = mkLiteral "black / 60%";
		cursor = "default";
	    };
	    "mainbox" = {
		enabled = "true";
		spacing = "100px";
		margin = "0px";
		padding = mkLiteral "50px 120px";
		border = mkLiteral "0px solid";
		border-radius = mkLiteral "0px 0px 0px 0px";
		border-color = "@selected";
		background-color = "transparent";
		children = mkLiteral '' ["inputbar", "listview"] '';
	    };
	    "inputbar" = {
		enabled = true;
		spacing = "10px";
		margin = mkLiteral "0% 28%";
		padding = "10px";
		border = "1px solid";
		border-radius = "6px";
		border-color = mkLiteral "white / 25%";
		background-color = mkLiteral "white / 5%";
		text-color = "@foreground";
		children = mkLiteral '' ["prompt", "entry"] '';
	    };
	    "prompt" = {
		enabled = "true";
		background-color = "transparent";
		text-color = "inherit";
	    };
	    "textbox-prompt-colon" = {
		enabled = "true";
		expand = "false";
		str = "::";
		background-color = "transparent";
		text-color = "inherit";
	    };
	    "entry" = {
		enabled = "true";
		background-color = "transparent";
		text-color = "inherit";
		cursor = "text";
		placeholder = "Search";
		placeholder-color = "inherit";
	    };
	    "listview" = {
		enabled = "true";
		columns = "6";
		lines = "4";
		cycle = "true";
		dynamic = "true";
		scrollbar = "false";
		layout = "vertical";
		reverse = "false";
		fixed-height = "true";
		fixed-columns = "true";
		spacing = "0px";
		margin = "0px";
		padding = "0px";
		border = mkLiteral "0px solid";
		border-radius = "0px";
		border-color = "@selected";
		background-color = "transparent";
		text-color = "@foreground";
		cursor = "default";
	    };
	    "scrollbar" = {
		handle-width = "5px";
		handle-color = "@selected";
		border-radius = "0px";
		background-color = "@background-alt";
	    };
	    "element" = {
		enabled = true;
		spacing = "15px";
		margin = "0px";
		padding = mkLiteral "35px 10px";
		border = mkLiteral "0px solid";
		border-radius = "15px";
		border-color = "@selected";
		background-color = "transparent";
		text-color = "@foreground";
		orientation = "vertical";
		cursor = "pointer";
	    };
	    "element.normal.normal" = {
		background-color = "transparent";
		text-color = "@foreground";
	    };
	    "element.alternate.normal" = {
	    	background-color = "transparent";
		text-color = "normal";
	    };
	    "element selected.normal" = {
		background-color = mkLiteral "white / 5%";
		text-color = "@foreground";
	    };
	    "element-icon" = {
		background-color = "transparent";
		text-color = "inherit";
		size = "2em";
		cursor = "inherit";
	    };
	    "element-text" = {
		background-color = "transparent";
		text-color = "inherit";
		highlight = "inherit";
		cursor = "inherit";
		vertical-align = "0.5";
		horizontal-align = "0.5";
	    };
	    "error-message" = {
		padding = "100px";
		border = mkLiteral "0px solid";
		border-radius = "0px";
		border-color = "@selected";
		background-color = mkLiteral "black / 10%";
		text-color = "@foreground";
	    };
	    "textbox" = {
		background-color = "transparent";
		text-color = "@foreground";
		vertical-align = "0.5";
		horizontal-align = "0.0";
		highlight = "none";
	    };
	};
    };
}
