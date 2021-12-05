note
	description: "Main application root class"

class
	MAIN

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
		local
			G:GAMEOFLIFE
		do
			create G.make
			G.main (10,10,0.6)
		end

end
