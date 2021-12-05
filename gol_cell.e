note
	description: "Class for inividual cells for the GOL Grid"

class
	GOL_CELL
create
	make

feature
	grid : detachable ARRAY2[GOL_CELL] -- Position of cell in the grid
	grid_x : INTEGER
	grid_y : INTEGER
	max_x : INTEGER
	max_y : INTEGER
	is_living : BOOLEAN	-- Status of the cell is true if cell is currently living
	is_living_next: detachable BOOLEAN	-- Determine if the cell is living in the current and next iteration	


	make(x : INTEGER; y: INTEGER; lives : BOOLEAN)
		do
			grid_x := x
			grid_y := y
			is_living := lives
		end


	setgrid(grid_of_cells : ARRAY2[GOL_CELL])
		do
			grid := grid_of_cells
			max_x := grid_of_cells.width
			max_y := grid_of_cells.height
		end


	neighbours : LINKED_LIST[GOL_CELL] -- Returns the surrounding cells of the current cell
		local
			total_neighbours : LINKED_LIST[GOL_CELL]
			i : INTEGER  --y
			j : INTEGER  --x
		do
			create total_neighbours.make

			from
			    i := grid_y-1
			until
			    i > grid_y+1
			loop
				from
				    j := grid_x-1
				until
				    j > grid_x+1
				loop  -- check that grid is not void and extend the cell to the list total_neighbours
					if i > 0 and j > 0 and i <= max_y and j <= max_x then
						if j /= grid_x or i /= grid_y then  --not both at the same time (current cell)
							check attached grid as f then
								total_neighbours.extend (f.item(i,j))
							end --end check
						end
					end --end if

					j := j + 1
				end --end j loop
				i := i + 1
			end --end i loop
			Result := total_neighbours
		end --end neighbors


	next -- Sets is_living_next based on the surrounding cells of the current iteration using neighbours
		local
			living_neighbours : INTEGER
			total_neighbours : LINKED_LIST[GOL_CELL]
		do
			living_neighbours := 0
			total_neighbours := neighbours

			across total_neighbours as surrounding_cell loop -- Count surrounding cells
				if surrounding_cell.item.is_living then
					living_neighbours := living_neighbours + 1
				end --end if
			end --end across

			if is_living then
				if living_neighbours = 2 or living_neighbours = 3 then
					is_living_next := TRUE  -- Rule #1 -> CELL is only living in the next itereation if it has exactly 2 or 3 living neighbours
				else
					is_living_next := FALSE -- Rule #2+#3
				end

			else
				if living_neighbours = 3 then
					is_living_next := TRUE -- Rule #4 -> If cell is dead, it is living in the next iteration if it has exactly 3 neighbours
				else
					is_living_next := FALSE
				end

			end
	end --end next

	update_living
		do
			is_living := is_living_next
		end
end --end class
