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
		nbexemplaire := 0
		create iu.make
	end
	init (t:STRING; an:STRING; nb:INTEGER) is
			-- Creation d'un utilisateur
		do
			titre := t
			nbexemplaire := nb
		end

feature {ANY}
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
	print_media is deferred end

	is_equals(object:MEDIA):BOOLEAN is deferred end

	is_equal_to(terme:STRING; t:STRING):BOOLEAN is deferred end 
	
	get_class:STRING is deferred end

	to_file_string:STRING is deferred end

end -- class TOWER
