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
		do
			id := i
		end
	set_nom(n:STRING) is
		do
			nom := n
		end
	set_prenom(p:STRING) is
		do
			prenom := p
		end
	get_id : STRING is
		do
			Result := id
		end
	set_isadmin(p:BOOLEAN) is
		do
			isadmin := p
		end
	get_isadmin : BOOLEAN is
		do
			Result := isadmin
		end
	get_nom : STRING is
		do
			Result := nom
		end
	get_prenom : STRING is
		do
			Result := prenom
		end
	print_utilisateur is
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
		end
	--
	
	
end 
