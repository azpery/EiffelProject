class STATISTIQUE

creation{ANY}
	make

feature{}
	iu:IU
	mediatheque:MEDIATHEQUE
	letop:ARRAY[TOP]

feature{ANY}
	make(m:MEDIATHEQUE) is
	require
		mediatheque:m /= Void
	do
		create iu.make
		mediatheque := m
	
	end

	enter is
	local
		choix:INTEGER
	do
		from 
			choix := 1
		until(choix = 0)
		loop
			choix := iu.show_multiple_choice("Afficher les statistiques","Menu gestion des utilisateurs")
			inspect choix
			when 1 then
				afficher_stats
			else		
			end
		end
	end



	afficher_stats is
	local
		
	do
		io.put_string("Nombre total d'utilisateurs: ")
		io.put_string((mediatheque.get_gestion_utilisateur.get_all_user.count -1 ).to_string + "%N")
		io.put_string("Nombre total d'emprunts: ")
		io.put_string((mediatheque.get_gestion_emprunt.get_all_emprunts.count -1).to_string + "%N")
		io.put_string("Nombre d'emprunt en cours: ")
		io.put_string((mediatheque.get_gestion_emprunt.get_emprunt_en_cours(mediatheque.get_gestion_emprunt.get_all_emprunts).count -1).to_string)
		io.put_string(" dont ")
		io.put_string((mediatheque.get_gestion_emprunt.get_emprunt_en_retard(mediatheque.get_gestion_emprunt.get_all_emprunts).count -1).to_string)
		io.put_string(" en retard." + "%N")
		io.put_string("Nombre de réservation en cours: ")
		io.put_string((mediatheque.get_gestion_emprunt.get_resa.count -1 ).to_string + "%N")
		io.put_string("%N")
		get_top_media

		
	end



--: ARRAY[TOP]
	get_top_media  is
	local
		top:TOP
		i, j:INTEGER
		lesemprunts:ARRAY[EMPRUNT]
		trouve:BOOLEAN
		--letop:ARRAY[TOP]
	do
		create top.make
		create letop.make(0,0)
		lesemprunts := mediatheque.get_gestion_emprunt.get_all_emprunts
		from
			i:=1
		until(i = lesemprunts.count)
		loop
			if(i = 1) then
				create top.init(lesemprunts.item(i).get_media.get_id, 1)
				letop.add_last(top)	
			else

				from
					j:=1
					trouve := False
				until(j=letop.count or trouve)
				loop
				
					if(lesemprunts.item(i).get_media.get_id.is_equal(letop.item(j).get_name)) then
						trouve := True
						letop.item(j).set_number(letop.item(j).get_number + 1)
					else
						j := j + 1
					end
					
				end
				if(not trouve) then
					create top.init(lesemprunts.item(i).get_media.get_id, 1)
					letop.add_last(top)
				else
				end
				
			end
			i := i + 1
		end
		trier_le_top
		io.put_string("Top 5 des emprunts: %N")
		afficher_top_cinq
		io.put_string("%N")
		io.put_string("Flop des emprunts : %N")
		afficher_flop_cinq
		
	end	
	




	afficher_all_top is
	local
		i:INTEGER
		top:TOP
	do
		
		from
			i := 1
		until(i = letop.count)
		loop
			top := letop.item(i)
			top.print_top
			i := i + 1 
		end

	end

	afficher_top_cinq is
	local
		i:INTEGER
		top:TOP
	do
		
		from
			i := 1
		until(i = 6 or i = letop.count)
		loop
			top := letop.item(i)
			io.put_string(i.to_string + "- ")
			top.print_name
			i := i + 1 
		end

	end

	afficher_flop_cinq is
	local
		diff, i, j:INTEGER
		top:TOP
	do	
		diff := letop.count - 5
		
		from
			i := letop.count - 1
			j := 1
		until(j = 6 or i = letop.count - diff)
		loop
			top := letop.item(i)
			top.print_name
			i := i - 1 
			j := j + 1
		end

	end

	trier_le_top is
	local
		i, j:INTEGER
		top:TOP
		letop5:ARRAY[TOP]
		temp:TOP
	do
		
		create letop5.make(0,0)
		from
			i := 1
		until(i = letop.count)
		loop
			create top.make	
			from
				j :=  i + 1 
			until(j = letop.count)
			loop
				create temp.make
				if(letop.item(i).get_number < letop.item(j).get_number) then
					
					temp:=letop.item(i)	
					--letop.item(i). := letop.item(j)
					--letop.item(j) := letop.item(i)
					--letop.remove(j +1)
					letop.add(letop.item(j), i)
					letop.remove(j +1)
					letop.add(temp, j)
					letop.remove(i +1)
					--remove (index: INTEGER)
					--letop.swap(i, j)
					--letop.put(letop.item(i), j)
					--letop.put(temp, i)
				 
					
				else
						
				end
				j := j + 1
			
			end
			
			i := i + 1 
		end
		--afficher_top_cinq
	end
	
	

end -- class STATISTIQUE
