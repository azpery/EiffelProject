class GESTIONMEDIA

creation{ANY}
	make

feature{}
	lesmedias:ARRAY[MEDIA]
	lesdvd:ARRAY[MEDIA]
	leslivres:ARRAY[MEDIA]
	iu:IU
	media_path:STRING

feature{ANY}

	make is
	do
		media_path := "medias.txt"
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
			choix := iu.show_multiple_choice("Ajouter un nouveau média;Rechercher un media;Modifier un média;Sauvegarder","Menu gestion des medias")
			inspect choix
			when 1 then
				ajouter
			when 2 then 
				rechercher_media
			when 3 then 
				modifier_media
			when 4 then 
				save
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
		lesmedias := parser.parse_media(media_path, "none")
		lesdvd := parser.parse_media(media_path, "dvd")
		leslivres := parser.parse_media(media_path, "livre")
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

	modifier_media is
	--Méthode de modification de média
	local
		focus:MEDIA
		choix:STRING
	do
		choix := ""
		from
			choix := choix
		until(choix.is_equal("q"))
		loop
			choix := iu.ask_question("Rechercher un média à modifier(q pour quitter)")
			focus := select_media(choix)
			if(focus /= Void) then
				focus.modifier_media
				save
			end
		end
	end

	ajouter is
	--méthode d'ajout de média
	local
		dvd:DVD
		livre:LIVRE
		choix:INTEGER
	do
		choix := iu.show_multiple_choice("Ajouter un livre;Ajouter un DVD","Ajouter un média")
		inspect choix
		when 2 then
			create dvd.make
			dvd.set_media
			lesdvd.add_last(dvd)
		when 1 then
			create livre.make
			livre.set_media
			leslivres.add_last(livre)
		else		
		end
		save
		io.put_string("Média ajouté avec succés")
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
			choix := iu.show_multiple_choice("Recherche rapide;Afficher la liste des medias charges;Afficher les DVD;Afficher les livres","Menu gestion des médias")
			inspect choix
			when 1 then
				print_medias(rechercher(iu.ask_question("Entrez votre recherche"), ""))
			when 2 then
				afficher_medias(lesmedias)
			when 3 then
				afficher_medias(lesdvd)
			when 4 then
				afficher_medias(leslivres)
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
			if(media.is_equal_to(terme, type)) then
				res.add_last(media)
			end
			i := i + 1 
		end

		from
			i :=  1
		until(i = leslivres.count)
		loop
			media := leslivres.item(i)
			if(media.is_equal_to(terme, type)) then
				res.add_last(media)
			end
			i := i + 1 
		end
		Result := res
	end

	save is
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
		iu.to_file(media_path, res)
	end

	select_media(term_recherche:STRING):MEDIA is
	local
		focus:ARRAY[MEDIA]
		res:MEDIA
		choix:STRING
	do
		focus := rechercher(term_recherche, "")
		print_medias(focus)
		if(focus.upper > 0) then
			from
				choix := ""
			until(choix.is_integer and then choix.to_integer <= focus.upper and then choix.to_integer > 0)
			loop
				choix := iu.ask_question("Quel média voulez-vous sélectionner?(q pour quitter)")
				if(choix.is_integer and then choix.to_integer <= focus.upper and then choix.to_integer > 0)then
					res := focus.item(choix.to_integer)
				end
			end
		else
			io.put_string("Aucun média n'a été trouvé%N")			
		end
		Result := res
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
