deferred class MEDIA
-- Represente un utilisateur de la médiathèque

feature {}
	titre:STRING
	nbexemplaire:INTEGER
	iu:IU
feature {}
	super_make is
	do
		titre := "Pas de titre"
		nbexemplaire := 0
		create iu.make
	end
	make is
	do
		titre := "Pas de titre"
		nbexemplaire := 1
		create iu.make
	end

feature {ANY}

	add_emprunt(utilisateur:UTILISATEUR):EMPRUNT is
	--Prend en paramètre un utilisateur et renvoie un emprunt Void ou non si l'utilisateur décide d'annuler ou si il y a pas la queantité suffisante
	require
		utilisateur_correct: utilisateur /= Void
	local
		emprunt:EMPRUNT
	do
		create emprunt.init(utilisateur, Current)
		if(nbexemplaire > 0)then
			if(iu.confirm(utilisateur.get_prenom+", êtes vous sur de vouloir emprunter "+titre+"%NVous aurez jusqu'au "+emprunt.get_date_retour+" avant de rendre le "+get_class+"%N(o pour oui, n pour non)"))then
				nbexemplaire := nbexemplaire - 1
			else
				emprunt := Void
			end
		else
			emprunt := Void
			io.put_string("Quantité disponible insuffisante")
		end
		Result := emprunt
	end

	add_exemplaire is
	--Ajout d'un exemplaire au media
	do
		nbexemplaire := nbexemplaire + 1
	end	

	print_media is deferred end

	is_equals(object:MEDIA):BOOLEAN is deferred end

	is_equal_to(terme:STRING; t:STRING):BOOLEAN is deferred end 
	
	get_class:STRING is deferred end

	to_file_string:STRING is deferred end

	set_media is deferred end

	modifier_media is deferred end
	--GETTER SETTER
	get_id:STRING is deferred end
	set_titre(i:STRING) is
	do
		titre := i
	end
	get_titre : STRING is
	do
		Result := titre
	end
	set_nbexemplaire(p:INTEGER) is
	do
		nbexemplaire := p
	end
	get_nbexemplaire : INTEGER is
	do
		Result := nbexemplaire
	end
end -- class MEDIA
