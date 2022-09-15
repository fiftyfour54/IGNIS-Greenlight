local function add_to_lookup_table(t,val,...)
	for _,entry in ipairs({...}) do
		t[entry]=val
	end
end

function Auxiliary.AddListedNames(s,...)
	s.listed_names=s.listed_names or {}
	add_to_lookup_table(s.listed_names,true,...)
end

function Auxiliary.AddListedSeries(s,...)
	s.listed_series=s.listed_series or {}
	add_to_lookup_table(s.listed_series,true,...)
end

function Auxiliary.AddListedCardType(s,...)
	s.listed_card_types=s.listed_card_types or {}
	add_to_lookup_table(s.listed_card_types,true,...)
end

function Auxiliary.AddMaterialNames(s,...)
	s.material_names=s.material_names or {}
	add_to_lookup_table(s.material_names,true,...)
end

function Auxiliary.AddMaterialSeries(s,...)
	s.material_series=s.material_series or {}
	add_to_lookup_table(s.material_series,true,...)
end

function Auxiliary.AddPlaceableCounters(s,...)
	s.listed_counters=s.listed_counters or {}
	--"1" denotes the counter can be placed
	add_to_lookup_table(s.listed_counters,1,...)
end

function Auxiliary.AddListedCounters(s,...)
	s.listed_counters=s.listed_counters or {}
	--do not use helper function to not overwrite placeable counters (already set to 1)
	for _,entry in ipairs({...}) do
		if t[entry]==nil then t[entry]=val end
	end
end

------------------------------------------------------------------

local function is_in_lookup_table(t,...)
	if not t then return false end
	for _,entry in ipairs({...}) do
		if t[entry] then return true end
	end
	return false
end

--Returns true if the Card "c" specifically lists any of the card IDs in "..."
function Card.HasListedName(c,...)
	return is_in_lookup_table(c.listed_names,...) -- or check_table(s.fit_material,...) -- is this needed?
end

--Returns true if the Card "c" lists any of the archetype codes in "..."
function Card.HasListedSeries(c,...)
	return is_in_lookup_table(c.listed_series,...)
end

--Returns true if the Card "c" lists any of the card IDs in "..." as material
function Card.HasListedMaterialName(c,...)
	return is_in_lookup_table(c.material_names,...)
end

local function match_set_code(set_code,to_match)
    return (set_code&0xfff)==(to_match&0xfff) and (set_code&to_match)==set_code
end

--Returns true if the Card "c" lists any of the archetype codes in "..." as material
function Card.HasListedMaterialSeries(c,...)
	if not c.material_series then return false end
	for _,setcode in ipairs({...}) do
		for listed in pairs(c.material_series) do
			if match_set_code(setcode,listed) then return true end
		end
	end
	return false
end

--Returns true if the Card "c" lists a card ID belonging in any of the archetypes in "..."
function Card.HasListedCardWithSetcode(c,...)
	if not c.listed_names then return false end
	local setcodes={...}
	if #setcodes==0 then return false end
	for _,cardcode in pairs(c.listed_names) do
		local match_setcodes={Duel.GetCardSetcodeFromCode(cardcode)}
		for _,to_match in ipairs(match_setcodes) do
			for _,setcode in ipairs(setcodes) do
				if match_set_code(setcode,to_match) then return true end
			end
		end
	end
	return false
end

--Returns true if the Card "c" specifically lists any of the card types in "..."
function Card.HasListedCardType(c,...)
	return is_in_lookup_table(c.listed_card_types,...)
end

--Returns true if the Card "c" has an effect that places any of the counters in "..."
function Card.CanPlaceCounter(c,...)
	if not c.listed_counters then return false end
	for _,counter in ipairs({...}) do
		if c.listed_counters[counter]==1 then return true end
	end
	return false
end

--Returns true if the Card "c" has an effect that places any of the counters in "..."
function Card.HasListedCounter(c,...)
	return is_in_lookup_table(c.counter_list,...)
end