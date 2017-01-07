class LIVRE

inherit MEDIA
	redefine make end	

creation{ANY}
	 make,init

feature{}
	auteur : STRING

feature{ANY}
	make is 
	do
		super_make
		auteur := "Pas d'auteur"
	end
	init (t:STRING; au:STRING; nb:INTEGER) is
		-- Creation d'un utilisateur
	do
		titre := t
		nbexemplaire := nb
		auteur:= au
	end

	set_media is
	--Méthode pour renseigner tous les champs de l'objet
	local
		ok: BOOLEAN
	do
		titre.copy(iu.ask_question("Renseigner le titre"))
		auteur.copy(iu.ask_question("Renseigner l'auteur"))
		
		from
			ok:= False
		until(ok=True)
		loop
			io.put_string("Renseigner le nombre d'exemplaires disponibles :")
			io.read_line
			if(io.last_string.is_integer)then
				ok:=True
				nbexemplaire := io.last_string.to_integer
			else
				io.put_string("Veuillez entrez un nombre %N")
			end
		end	
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
			c := iu.show_multiple_choice("Modifier le titre;Modifier l'auteur;Modifier le nombre d'exemplaires","Modification de "+titre)
			inspect c
			when 1 then
				titre.copy(iu.ask_question("Renseigner le titre"))
			when 2 then 
				auteur.copy(iu.ask_question("Renseigner l'auteur"))
			when 3 then 
				nbexemplaire := iu.ask_question("Renseigner le nombre d'exemplaires disponibles").to_integer
			else		
			end
		end
	end

	print_media is
	--Affiche le livre
	do
		iu.put_centered_string(titre, '*')
		io.put_string("%N")
		io.put_string("Auteur:")
		io.put_string(auteur)
		io.put_string("%N")
		io.put_string("Nombre d'exemplaire disponibles:")
		io.put_integer(nbexemplaire)
		io.put_string("%N")
	end

	to_file_string:STRING is
	--Retourne l'objet prêt pour l'export vers un fichier
	do
		Result := "Livre ; Titre<"+titre+"> ; Auteur<"+auteur+"> ; Nombre<"+nbexemplaire.to_string+">" 
	ensure 
		not_empty: not Result.is_empty
	end

	is_equals(object:LIVRE):BOOLEAN is
	--Retourne vrai si l'auteur est le même et le titre est le même
	do
		Result := object.get_auteur.is_equal(get_auteur) and object.get_titre.is_equal(get_titre)
	end

	is_equal_to(terme:STRING; t:STRING):BOOLEAN is
	--Retourne vrai s'il le dvd correspond aux critères de recherche
	--Si le type t de recherche est vide, il recherchera dans tous les champs du livre
	--On peut rechercher avec le titre, le nom de l'auteur ou l'id 
	do
		Result := False
		if(t.is_equal("titre") and get_titre.is_equal(terme))then
			Result := True
		elseif(t.is_equal("auteur") and get_auteur.is_equal(terme))then
			Result := True
		elseif(t.is_equal("id") and get_id.is_equal(terme))then
			Result := True
		elseif(t.is_equal("") and get_auteur.is_equal(terme) or get_titre.is_equal(terme))then
			Result := True
		end
	end

	get_id:STRING is
	--Retourne un identifiant unique au média
	do
		Result := titre+auteur
	end

	--GETTER SETTER
	set_auteur (a : STRING) is
	do
		auteur := a
	end

	get_auteur : STRING is
	do
		Result := auteur
	end
	get_class:STRING is
	do
		Result := "LIVRE"
	end

end -- class LIVRE
