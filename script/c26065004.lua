--Entrophys Regulator of Solids
function c26065004.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c26065004.matfilter,1,1)
	--transform monsters
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c26065004.limit)
	e1:SetValue(0x665)
	c:RegisterEffect(e1)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetCountLimit(1)
	e2:SetDescription(aux.Stringid(26065004,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c26065004.condition)
	e2:SetTarget(c26065004.target)
	e2:SetOperation(c26065004.operation)
	c:RegisterEffect(e2)
end
function c26065004.matfilter(c,lc,sumtype,tp)
	return c:IsSummonCode(lc,sumtype,tp,26065001) or
	c:IsSummonCode(lc,sumtype,tp,26065002) or
	c:IsSummonCode(lc,sumtype,tp,26065003) or
	c:IsSummonCode(lc,sumtype,tp,26068017)
end
c26065004.listed_series={0x665}
function c26065004.limit(e,c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c26065004.regfilter(c,e,tp)
	local ap=e:GetHandlerPlayer()
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost() and c:IsOriginalSetCard(0x665)
end
function c26065004.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x665)
end
function c26065004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26065004.regfilter,tp,LOCATION_GRAVE,0,1,nil,e,rp) end
	
end
function c26065004.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local rg=Duel.GetMatchingGroup(c26065004.regfilter,tp,LOCATION_GRAVE,0,nil,e,rp)
	if #rg==0 then return end
	local op,opt,tc=false,-2,nil
	while opt==-2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=rg:Select(tp,1,1,nil):GetFirst()
		if tc:GetOriginalCode()==26065001 then
			opt=Duel.SelectOption(tp,aux.Stringid(26065001,0),aux.Stringid(26065001,1),aux.Stringid(26065004,1))
			if opt==0 then op=c26065001.operation end
			if opt==1 then op=c26065001.spop end
			if opt==2 then opt=-2 end
		end
		if tc:GetOriginalCode()==26065002 then
			opt=Duel.SelectOption(tp,aux.Stringid(26065002,0),aux.Stringid(26065002,1),aux.Stringid(26065004,1))
			if opt==0 then op=c26065002.operation end
			if opt==1 then op=c26065002.spop end
			if opt==2 then opt=-2 end
		end
		if tc:GetOriginalCode()==26065003 then
			opt=Duel.SelectOption(tp,aux.Stringid(26065003,0),aux.Stringid(26065003,1),aux.Stringid(26065004,1))
			if opt==0 then op=c26065003.operation end
			if opt==1 then op=c26065003.spop end
			if opt==2 then opt=-2 end
		end
		if tc:GetOriginalCode()==26068017 then
			opt=Duel.SelectOption(tp,aux.Stringid(26068017,0),aux.Stringid(26068017,1),aux.Stringid(26065004,1))
			if opt==0 then op=c26068017.tgop end
			if opt==1 then op=c26068017.spop end
			if opt==2 then opt=-2 end
		end
		if opt~=-2 then
			Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)
			Duel.ChangeTargetCard(ev,g)
			Duel.ChangeChainOperation(ev,op)
			return
		end
	end
end