class TOP
-- Represente un emprunt de la médiathèque

creation{ANY}
	 make, init

feature {}
	name:STRING
	number:INTEGER
	


feature {ANY}
	make is
	do
		name := "Null"
		number := 0
	end

	init(nom:STRING; nombre:INTEGER) is
	require
		nomnotvoid:nom /= Void
	do
		name := nom
		number := nombre
	end
	
	set_name(nom:STRING) is
	--Modifie nom
	require
		nomnotvoid:nom /= Void
	do
		name := nom
	end
	
	get_name:STRING is
	--Renvoie le nom
	do
		Result := name
	end

	set_number(nombre:INTEGER) is
	--Modifie nombre
	do
		number := nombre
	end

	get_number:INTEGER is
	--Retourne nombre
	do
		Result := number
	end

	print_top is
	--Affiche les données
	do
		io.put_string("Titre:")
		io.put_string(name)
		io.put_string("%N")
		io.put_string("Nombre:")
		io.put_string(number.to_string)
		io.put_string("%N")
		
	end

	print_name is
	--Affiche le nom
	do
		io.put_string(name)
		io.put_string("%N")
		
	end


end -- class TOP
