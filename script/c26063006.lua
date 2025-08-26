--Stelloy Commander - Stein
function c26063006.initial_effect(c)
	Xyz.AddProcedure(c,nil,4,2,c26063006.ovfilter,aux.Stringid(26063006,1),Xyz.InfiniteMats,c26063006.xyzop)
	c:EnableReviveLimit()
	--gemini
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IMMEDIATELY_APPLY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c26063006.spop)
	c:RegisterEffect(e1)
	--cycle mats
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26063002,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(26063002)
	e2:SetCountLimit(1,26063002)
	e2:SetCost(c26063006.cost)
	e2:SetCondition(Gemini.EffectStatusCondition)
	c:RegisterEffect(e2,false,REGISTER_FLAG_DETACH_XMAT)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26063003,1))
	e3:SetLabel(26063003)
	e3:SetCountLimit(1,26063003)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(26063004,1))
	e4:SetLabel(26063004)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,26063004)
	c:RegisterEffect(e4,false,REGISTER_FLAG_DETACH_XMAT)
	local e5=e2:Clone()
	e5:SetDescription(aux.Stringid(26063005,1))
	e5:SetLabel(26063005)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,26063005)
	c:RegisterEffect(e5,false,REGISTER_FLAG_DETACH_XMAT)
	local e6=e2:Clone()
	e6:SetDescription(aux.Stringid(26068042,0))
	e6:SetLabel(26068042)
	e6:SetCountLimit(1,26068042)
	c:RegisterEffect(e6,false,REGISTER_FLAG_DETACH_XMAT)
	local e7=e2:Clone()
	e7:SetDescription(aux.Stringid(26068077,1))
	e7:SetLabel(26068077)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1,26068077)
	c:RegisterEffect(e7,false,REGISTER_FLAG_DETACH_XMAT)
	
end
c26063006.StelloyEff1=true
function c26063006.ovmtg(e,c)
	return c==e:GetHandler() and (c:IsType(TYPE_EFFECT) or c:IsGeminiState())
end
function c26063006.ovfilter(c,tp,xc)
	return c:IsFaceup() and c:GetLevel()==4 and c:IsSetCard(0x663,xc,SUMMON_TYPE_XYZ,tp)
end
function c26063006.xyzop(e,tp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	c:RegisterFlagEffect(26063006,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetDescription(aux.Stringid(26063006,0))
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD -RESET_TOFIELD)
	e1:SetCountLimit(1)
	e1:SetCondition(c26063006.xcon)
	e1:SetTarget(c26063006.xtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD -RESET_TOFIELD)
	e2:SetValue(TYPE_EFFECT)
	e2:SetCondition(Gemini.NormalStatusCondition)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	return true
end
function c26063006.xcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c26063006.mtfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil,c)
	return not c:IsGeminiState() and #g>0 and Duel.GetFlagEffect(tp,26063006)==0
end
function c26063006.mtfilter(c,sc)
	return c:GetLevel()==4 and c:IsType(TYPE_GEMINI)
end
function c26063006.rescon(sg,e,tp,mg)
	return 
	#sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<2 and
	#sg:Filter(Card.IsLocation,nil,LOCATION_MZONE)<2 and
	#sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<2
end
function c26063006.xtg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local rk=c:GetRank()
	local g=Duel.GetMatchingGroup(c26063006.mtfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	sg=aux.SelectUnselectGroup(g,e,tp,1,3,c26063006.rescon,1,tp,aux.Stringid(26063006,1),nil,nil,true)
	if #sg>0 and Duel.Overlay(c,sg)~=0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(TYPE_EFFECT)
		e2:SetRange(LOCATION_MZONE)
		c:RegisterEffect(e2)
		c:EnableGeminiState()
		Duel.RegisterFlagEffect(tp,26063006,RESET_PHASE+PHASE_END,0,1)
		return true
	end
	return false
end
function c26063006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(26063006)==0 then
		c:EnableGeminiStatus()
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,64)
	end
end
function c26063006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(Card.IsCode,nil,e:GetLabel())
	if chk==0 then return #g>0 and g:GetFirst().target(e,tp,eg,ep,ev,re,r,rp,chk) and c:GetFlagEffect(26063001)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	c:RegisterFlagEffect(26063001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	e:SetTarget(tc.target)
	e:SetOperation(tc.operation)
end