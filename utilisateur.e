class UTILISATEUR
-- Represente un utilisateur de la médiathèque
	
creation {ANY}
	init, make

feature {}
	id:STRING
	nom:STRING
	prenom:STRING
	isadmin:BOOLEAN
feature {}
	make is
	do
		nom := "pas de nom"
		prenom := "pas de prénom"
		id := "NoId"
		isadmin := False
	end

	init (login:STRING; n:STRING; p:STRING; isa:BOOLEAN) is
		-- Creation d'un utilisateur
	do
		id := login
		nom := n
		prenom := p
		isadmin := isa
	end

feature {ANY}
	set_id(i:STRING) is
	--Modifie l'id utilisateur
	require
		idnotvoid:i /= Void
	do
		id := i
	end

	set_nom(n:STRING) is
	--Modifie le nom
	require
		nomnotvoid:n /= Void
	do
		nom := n
	end

	set_prenom(p:STRING) is
	--Modifie le prenom
	require
		prenomnptvoid:p /= Void
	do
		prenom := p
	end

	get_id : STRING is
	--Renvoie l'id
	do
		Result := id
	end

	set_isadmin(p:BOOLEAN) is
	--Modifie le statut (admin ou non)
	do
		isadmin := p
	end

	get_isadmin : BOOLEAN is
	--Renvoie le statut
	do
		Result := isadmin
	end

	get_nom : STRING is
	--Renvoie le nom
	do
		Result := nom
	end

	get_prenom : STRING is
	--Renvoie le prénom
	do
		Result := prenom
	end

	print_utilisateur is
	--Affiche les données d'un utilisateur
	do
		io.put_string("Login:")
		io.put_string(id)
		io.put_string("%N")
		io.put_string("Nom:")
		io.put_string(nom)
		io.put_string("%N")
		io.put_string("Prénom:")
		io.put_string(prenom)
		io.put_string("%N")
	end

	to_file_string: STRING is
	local
		ligne:STRING
	do
		if(isadmin)then
			ligne:= "Nom<" + nom + "> ; Prenom<" + prenom + "> ; Identifiant<" + id + ">; Admin<OUI>"
		else
			ligne:= "Nom<" + nom + "> ; Prenom<" + prenom + "> ; Identifiant<" + id + ">"
		end
		Result:= ligne
	ensure 
		not_empty: not Result.is_empty
	end
	--
	
	
end 
