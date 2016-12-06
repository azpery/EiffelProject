class GESTIONMEDIA

creation{ANY}
	make

feature{}
	lesmedias:ARRAY[MEDIA]
	lesdvd:ARRAY[MEDIA]
	leslivres:ARRAY[MEDIA]
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
			choix := iu.show_multiple_choice("Afficher la liste des médias chargés;Afficher les DVD;Afficher les livres;Recharger les médias","Menu gestion des médias")
			inspect choix
			when 1 then
				afficher_medias(lesmedias)
			when 2 then
				afficher_medias(lesdvd)
			when 3 then
				afficher_medias(leslivres)
			when 4 then
				init_media
			when 5 then 
				rechercher_media
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
		lesmedias := parser.parse_media("./medias.txt", "none")
		lesdvd := parser.parse_media("./medias.txt", "dvd")
		leslivres := parser.parse_media("./medias.txt", "livre")
	end

	afficher_medias(liste:ARRAY[MEDIA]) is
		--Affichage en liste des médias chargés
	local
		i:INTEGER
		media:MEDIA
	do
		
		from
			i := liste.count - 1
		until(i = 1)
		loop
			media := liste.item(i)
			media.print_media
			i := i - 1 
		end
	end
	rechercher_media is
		--Menu de recherche de média
	local
		choix:INTEGER
	do
		choix := iu.show_multiple_choice("Rechercher un média par nom;Rechercher un DVD; Rechercher un livre", "Rechercher un media")
	end

end -- class IU
