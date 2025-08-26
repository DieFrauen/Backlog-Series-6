--Crystelloy Marshall - Diamundo
function c26063008.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,3,nil,nil,Xyz.InfiniteMats,nil,false,c26063008.xyzcheck)
	--gemini
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IMMEDIATELY_APPLY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26063008.spcon)
	e1:SetOperation(c26063008.spop)
	c:RegisterEffect(e1)
	--geminize
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IMMEDIATELY_APPLY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c26063008.gemcon)
	e2:SetOperation(c26063008.gemop)
	c:RegisterEffect(e2)
end
c26063008.StelloyEff1=true
c26063008.listed_names={26063001}
function c26063008.ovmtg(e,c)
	return c==e:GetHandler() or not c:IsType(TYPE_EFFECT)
end
function c26063008.xyzcheck(g,tp,xyz)
	return g:IsExists(Card.IsCode,1,nil,26063001)
end
function c26063008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()&SUMMON_TYPE_XYZ ==SUMMON_TYPE_XYZ 
end
function c26063008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26063008.gemfilter,tp,0,LOCATION_MZONE,nil)
	c26063008.geminize(c,g,1-tp)
end
function c26063008.gemfilter(c)
	return c:IsFaceup()
	and (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT 
	and (c:GetOriginalType()&TYPE_GEMINI)==0
	and not c:IsGeminiStatus()
end
function c26063008.gemcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26063008.gemfilter,1,e:GetHandler()) and eg:GetFirst():GetSummonPlayer()~=tp
end
function c26063008.gemop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c26063008.gemfilter,c)
	c26063008.geminize(c,g,1-tp)
end
function c26063008.geminize(c,g,tp)
	local tc=g:GetFirst()
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		--turn Gemini
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_GEMINI)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_EFFECT)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		e3:SetCondition(Gemini.NormalStatusCondition)
		e3:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e4)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_DISABLE_EFFECT)
		e5:SetDescription(aux.Stringid(26063008,0))
		e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		tc:RegisterEffect(e5)
		if tc:IsSummonableCard() then
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetDescription(aux.Stringid(26063008,1))
			e6:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e6:SetCode(EFFECT_GEMINI_SUMMONABLE)
			e6:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e6)
		end
		sg:AddCard(tc)
	end
	if #g>0 then
		Duel.Hint(HINT_CARD,tp,26063008)
		Duel.HintSelection(g)
	end
end