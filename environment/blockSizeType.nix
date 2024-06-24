{lib,config,...}:
with lib; with builtins; let
    opt = mkOption;
in {
    options.lib.types.blockSize = opt { type = attrs; default = {}; };
    config.lib.types.blockSize = mkOptionType {
	name = "Block Size";
	description = ''
	    a type-checked way to specify the size of blocks in <i>TB, <i>GB, <i>MB, <i>KB
	'';
	emptyValue = { value = ""; };

	check = (x: 
	    let
		split = splitString "" x; #=> list
		numbers = 
		    map 
			(y: toInt y)
			(filter (y: 
			    any (z: 
				y 
				== 
				z
			    ) 
			    ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"]
			) 
			split);
		num = toInt (foldr
		    (y: z: y + z)
		    ""
		    numbers
		);
	    in 
	    isString x
	    &&
	    isInt (head split)
	    &&
	    if (last split) == "B"
	    then
		if any 
		    (y: y == last 
			(filter 
			    (z: 
				(last split)
				!= 
				z
			    ) 
			split)
		    ["P" "T" "G" "M" "K"]
		    )
		then true else false
	    else false
	    && isInt num
	    && ((mod num 2) == 0)
	);
    };
}
