--The Desceptim Ars-Goetia
function c26067000.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,false,false,aux.FilterBoolFunctionEx(Card.IsType,TYPE_MONSTER),1,65,26067007,26067001,26067002,26067003,26067004,26067005,26067006)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c26067000.splimit)
	c:RegisterEffect(e0)
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c26067000.winop)
	c:RegisterEffect(e1)
end
c26067000.listed_series={0x667}
c26067000.material_setcode={0x667}
function c26067000.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c26067000.winop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetSummonPlayer()
	Duel.Win(p,WIN_REASON_CREATORGOD)
end