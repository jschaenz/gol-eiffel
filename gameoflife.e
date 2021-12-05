note
	description: "GOL Class"

class
	GAMEOFLIFE

inherit
	EXECUTION_ENVIRONMENT

create
	make

feature

	random_sequence: RANDOM

    new_random: INTEGER  -- generate random number
        do
            random_sequence.forth
            Result := random_sequence.item
        end


    rand_1_100: INTEGER  --returns random number from 1-100
        do
            Result := new_random \\ 100 + 1
        end


	update (grid : ARRAY2[GOL_CELL])
		local
			i : INTEGER  --width
			j : INTEGER	 --height
			c : GOL_CELL -- cell for iteration
		do
			from -- calls next for each cell
			    i := 1
			until
			    i > grid.height
			loop
			    from
			    j := 1
				until
				    j > grid.width
				loop
					c := grid.item (i,j)
					c.next

				    j := j + 1
				end --end j loop

			    i := i + 1
			end --end i loop


			from -- living gets set to the value of living_next that the next method has calculated
			    i := 1
			until
			    i > grid.height
			loop
			    from
			    	j := 1
				until
				    j > grid.width
				loop
					c := grid.item (i,j)
					c.update_living

				    j := j + 1
				end --end j loop

			    i := i + 1
			end --end i loop
		end -- end update


	draw (grid : ARRAY2[GOL_CELL]) -- draws a representation of grid, showing if cells are dead or alive
		local
				i : INTEGER
				j: INTEGER
				outputstr : STRING
				c : GOL_CELL -- cell for iteration

		do
			from
			    i := 1
			until
			    i > grid.height
			loop
				outputstr := ""

			    from
			   		j := 1
				until
				    j > grid.width
				loop
					c := grid.item (i,j)
					if c.is_living then
						outputstr := outputstr + " X "
					else
						outputstr := outputstr + " . "
					end --end if

				    j := j + 1
				end --end j loop "columns"
				outputstr := outputstr + "%N"
				print(outputstr)
			    i := i + 1
			 end --end i loop "rows"
		end


	main ( width : INTEGER; height: INTEGER; p : REAL)
		local
			-- Variables for iterating through grid
			i : INTEGER
			j : INTEGER
			k : INTEGER
			c : GOL_CELL
			d : GOL_CELL -- default cell
			living : BOOLEAN
			grid : ARRAY2[GOL_CELL]


		do
			create d.make(0,0,True) -- default cell for initialization, to avoid void in grid
			create grid.make_filled (d, height, width)

			from
			    i := 1
			until
			    i > height
			loop
			    from
			   		j := 1
				until
				    j > width
				loop -- determine if cell lives by using random and p

		            if rand_1_100 > p*100 then
		            	living := True
		            else
		            	living := False
		            end --end if

				    create c.make(j,i,living)  -- create instance of cell here and put cell in row
				    c.setgrid (grid)
				    grid.put (c, i, j)

				    j := j + 1
				end --end j loop

			    i := i + 1
			end --end i loop

			from -- run infinite while loop and call draw and update here
				k := 1
			until
				k < 0
			loop
				print("%NIteration: ")
				print(k)
				print("%N")
				draw(grid)
				update(grid)
				sleep(1000000000) --1000000000 == 1s
				k := k + 1
			end --end k loop
		end

	make
		local
			l_time: TIME
          	l_seed: INTEGER
		do
			create l_time.make_now
            l_seed := l_time.milli_second
            create random_sequence.set_seed (l_seed)
		end
end
