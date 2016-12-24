class DVD

inherit MEDIA
	redefine  make end	

creation{ANY}
	 make

feature{}
	annee : STRING
	realisateur: STRING
	acteur:ARRAY[STRING]
	type:STRING

feature{ANY}
	make is
	do
		super_make
		annee := "Pas d'année"
		realisateur := "Pas de réalisateur"
		type := ""
		create acteur.make(0,0)
		type := "Pas de type"
	end

	set_annee (a : STRING) is
	do
		annee := a
	end

	get_annee : STRING is
	do
		Result := annee
	end

	set_realisateur (r : STRING) is
	do
		realisateur := r
	end

	get_realisateur : STRING is
	do
		Result := realisateur
	end

	add_acteur (a : STRING) is
	local
		new_acteur:STRING
	do
		new_acteur := ""
		new_acteur.copy(a)
		acteur.add_last(new_acteur)
	end

	get_acteur : ARRAY[STRING] is
	do
		Result := acteur
	end

	set_type (r : STRING) is
	do
		type := r
	end

	get_type : STRING is
	do
		Result := type
	end
	get_class:STRING is
	do
		Result := "DVD"
	end

	set_media is
		--Méthode pour renseigner tous les champs de l'objet
	local
		choix:STRING
	do
		choix := ""
		titre.copy(iu.ask_question("Renseigner le titre:"))
		annee.copy(iu.ask_question("Renseigner l'année:"))
		realisateur.copy(iu.ask_question("Renseigner le nom du réalisateur:"))
		type.copy(iu.ask_question("Renseigner le type de packaging"))
		choix.copy(iu.ask_question("Renseigner le nom d'un acteur(laisser vide si non désiré):"))
		from 
			choix := choix
		until (choix.is_equal(""))
		loop
			add_acteur(choix)
			choix.copy(iu.ask_question("Renseigner le nom d'un acteur(laisser vide si non désiré):"))
		end
		nbexemplaire := iu.ask_question("Renseigner le nombre d'exemplaires disponibles:").to_integer
	end

	modifier_media is
		--Méthode pour renseigner tous les champs de l'objet
	local
		choix:STRING
		c:INTEGER
	do
		from
			c := 1
		until(c=0)
		loop
			choix := ""
			c := iu.show_multiple_choice("Modifier le titre;Modifier l'annee;Modifier le réalisateur;Modifier le type;Modifier le nombre d'exemplaires; Ajouter un acteur","Modification de "+titre)
			inspect c
			when 1 then
				titre.copy(iu.ask_question("Renseigner le titre:"))
			when 2 then 
				annee.copy(iu.ask_question("Renseigner l'année:"))
			when 3 then 
				realisateur.copy(iu.ask_question("Renseigner le nom du réalisateur:"))
			when 4 then 
				type.copy(iu.ask_question("Renseigner le type de packaging"))
			when 5 then 
				nbexemplaire := iu.ask_question("Renseigner le nombre d'exemplaires disponibles:").to_integer
			when 6 then 
				choix.copy(iu.ask_question("Renseigner le nom d'un acteur(laisser vide si non désiré):"))
				from 
					choix := choix
				until (choix.is_equal(""))
				loop
					add_acteur(choix)
					choix.copy(iu.ask_question("Renseigner le nom d'un acteur(laisser vide si non désiré):"))
				end
			else		
			end
		end
	end

	print_media is
	do
		
		iu.put_centered_string(titre, '*')
		io.put_string("Année:")
		io.put_string(annee)
		io.put_string("%N")
		io.put_string("Réalisateur:")
		io.put_string(realisateur)
		io.put_string("%N")
		io.put_string("Packaging:")
		io.put_string(type)
		io.put_string("%N")
		print_acteur
		io.put_string("Nombre d'exemplaire:")
		io.put_integer(nbexemplaire)
		io.put_string("%N")
	end
	
	print_acteur is
		local
			i:INTEGER
		do
			i := acteur.count - 1
			if(i > 0) then
				io.put_string("Liste des acteurs présents: %N")
			end			
			from
				i := acteur.count - 1
			until(i = 0)
			loop
				io.put_string("- " + acteur.item(i) + "%N")
				i := i - 1 
			end
		end
	



	is_equals(object:DVD):BOOLEAN is
	do
		Result := False
		if(object.get_realisateur.is_equal(get_realisateur) and object.get_titre.is_equal(get_titre))then
			Result := True
		end
	end

	is_equal_to(terme:STRING; t:STRING):BOOLEAN is
	do
		Result := False
		if(t.is_equal("annee") and get_annee.is_equal(terme))then
			Result := True
		elseif(t.is_equal("realisateur") and then get_realisateur.is_equal(terme))then
			Result := True
		elseif(t.is_equal("type") and then get_type.is_equal(terme))then
			Result := True
		elseif(t.is_equal("titre") and then get_titre.is_equal(terme))then
			Result := True
		elseif(t.is_equal("id") and then get_id.is_equal(terme))then
			Result := True
		elseif(t.is_equal("") and then get_annee.is_equal(terme) or get_realisateur.is_equal(terme) or get_type.is_equal(terme)or get_titre.is_equal(terme) or acteur_contains(terme))then
			Result := True
		end
	end

	acteur_contains(s:STRING):BOOLEAN is
	local
		i:INTEGER
		res:BOOLEAN
	do
		res := False
		from
			i := 1
		until(i = acteur.upper)
		loop
			if(acteur.item(i).is_equal(s))then	
				res := True
			end
			i := i + 1
		end
		Result := res
	end
	
	to_file_string:STRING is
	do
		Result := "DVD ; Titre<"+titre+"> ; Annee<"+annee+"> ; Realisateur<"+realisateur+">"+acteur_to_string + "; Nombre<"+nbexemplaire.to_string+">"
	end

	acteur_to_string:STRING is
	local
		i:INTEGER
		res:STRING
	do
		res := ""			
		from
			i := acteur.upper
		until(i = 0)
		loop
			res := res + "; Acteur<"+acteur.item(i)+">"
			i := i - 1 
		end
		Result := res
	end

	get_id:STRING is
	--Retourne un identifiant unique au média
	do
		Result := titre+annee
	end


end -- class LIVRE
