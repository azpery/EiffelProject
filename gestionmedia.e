class GESTIONMEDIA

creation{ANY}
	make

feature{}
	lesmedias:ARRAY[MEDIA]
	iu:IU

feature{ANY}
	make is
	do
		init_media
		create iu.make
	end

	enter is
	local
		choix:INTEGER
	do
		
		from 
			choix := 1
		until(choix = 0)
		loop
			choix := iu.show_multiple_choice("Afficher la liste des médias chargés;Recharger les médias","Menu gestion des médias")
			inspect choix
			when 1 then
				afficher_medias
			when 2 then
				init_media
			else		
			end
		end
	end

	init_media is
		--Chargement des médias 
	local
		parser:PARSER
	do
		create parser.make
		lesmedias := parser.parse_media("./medias.txt")
		
	end

	afficher_medias is
		--Affichage en liste des médias chargés
	local
		i:INTEGER
		media:MEDIA
	do
		
		from
			i := lesmedias.count - 1
		until(i = 1)
		loop
			media := lesmedias.item(i)
			media.print_media
			i := i - 1 
		end
	end

end -- class IU
