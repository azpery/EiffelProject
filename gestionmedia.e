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
			choix := iu.show_multiple_choice("Afficher la liste des medias charges;Afficher les DVD;Afficher les livres;Recharger les medias;Rechercher un media;Sauvegarder","Menu gestion des medias")
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
			when 6 then 
				exporter_medias
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
		from 
			choix := 1
		until(choix = 0)
		loop
			choix := iu.show_multiple_choice("Recherche rapide; Recherche avancée","Menu gestion des médias")
			inspect choix
			when 1 then
				print_medias(rechercher(iu.ask_question("Entrez votre recherche"), ""))
			when 2 then
				afficher_medias(lesdvd)
			else		
			end
		end
	end

	rechercher(terme:STRING; type:STRING):ARRAY[MEDIA] is
	--Prend en paramètre une liste de média, le terme de recherche et le filtre sur lequel appliquer le terme
	--Le type de filtre peut être : titre, auteur, ou autre.
	local
		i:INTEGER
		res:ARRAY[MEDIA]
		media:MEDIA
	do
		create res.make(0,0)
		from
			i :=  1
		until(i = lesdvd.count)
		loop
			media := lesdvd.item(i)
			if(media.is_equal_to(terme, "")) then
				res.add_last(media)
			end
			i := i + 1 
		end

		from
			i :=  1
		until(i = leslivres.count)
		loop
			media := leslivres.item(i)
			if(media.is_equal_to(terme, "")) then
				res.add_last(media)
			end
			i := i + 1 
		end
		Result := res
	end

	exporter_medias is
	local
		res:STRING
		i:INTEGER
		media:MEDIA
	do
		res := ""
		from
			i :=  1
		until(i = lesdvd.count)
		loop
			media := lesdvd.item(i)
			res := res + "%N" + media.to_file_string
			i := i + 1 
		end

		from
			i :=  1
		until(i = leslivres.count)
		loop
			media := leslivres.item(i)
			res := res + "%N" + media.to_file_string
			i := i + 1 
		end
		io.put_string(res)
	end

	print_medias(liste:ARRAY[MEDIA]) is
	local
		i:INTEGER
		media:MEDIA
	do
		from
			i :=  1
		until(i = liste.count)
		loop
			media := liste.item(i)
			io.put_string("" + i.to_string + "-")
			media.print_media
			i := i + 1 
		end
	end

end -- class IU
