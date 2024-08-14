--Stelloy Commander - Stein
function c26063006.initial_effect(c)
	Xyz.AddProcedure(c,nil,4,2,c26063006.ovfilter,aux.Stringid(26063006,1),99,c26063006.xyzop)
	c:EnableReviveLimit()
	--gemini
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IMMEDIATELY_APPLY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26063006.spcon)
	e1:SetOperation(c26063006.spop)
	c:RegisterEffect(e1)
	--cycle mats
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26063006,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(Gemini.EffectStatusCondition)
	e2:SetTarget(c26063006.thtg)
	e2:SetOperation(c26063006.thop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(Gemini.EffectStatusCondition)
	e3:SetTarget(c26063006.reptg)
	e3:SetValue(c26063006.repval)
	e3:SetOperation(c26063006.repop)
	c:RegisterEffect(e3)
end
c26063006.listed_names={26063001}
c26063006.StelloyEff1=true
function c26063006.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:GetLevel()==4 and c:IsRace(RACE_ROCK,lc,SUMMON_TYPE_XYZ,tp)
end
function c26063006.cfilter(c,mc)
	return c:IsRace(RACE_ROCK) and c:GetLevel()==4 and not c:IsCode(mc:GetCode())
end
function c26063006.rescon(sg,e,tp,mg)
	local lab=e:GetLabel()
	return sg:GetClassCount(Card.GetCode)==#sg and not sg:IsExists(Card.IsCode,1,nil,lab) and
	((lab==26063001 or sg:IsExists(Card.IsCode,1,nil,26063001)) and
	#sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<3 and
	#sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<3)
	or
	(#sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)==0 and
	#sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<3)
end
function c26063006.xyzop(e,tp,chk,mc)
	e:SetLabel(mc:GetCode())
	local g=Duel.GetMatchingGroup(c26063006.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,mc)
	if chk==0 then return Duel.GetFlagEffect(tp,26063006)==0 and aux.SelectUnselectGroup(g,e,tp,1,4,c26063006.rescon,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	sg=aux.SelectUnselectGroup(g,e,tp,1,4,c26063006.rescon,1,tp,aux.Stringid(26063006,1),nil,nil,true)
	if #sg>0 then
		Duel.Overlay(mc,sg)
		Duel.RegisterFlagEffect(tp,26063006,RESET_PHASE+PHASE_END,0,1)
		return true
	else return false end
end
function c26063006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_GEMINI)
end
function c26063006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,tp,26063006)
	c:EnableGeminiStatus()
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,64)
end
function c26063006.repval(e,c)
	local tp=e:GetHandlerPlayer()
	return c:IsFaceup()
	and c:GetControler()==tp
	and c:GetLocation()==LOCATION_MZONE 
	and c:IsReason(REASON_BATTLE)
	and (c:IsType(TYPE_GEMINI) or not c:IsType(TYPE_EFFECT))
end
function c26063006.repfilter(c,e)
	return not c:IsReason(REASON_REPLACE) and c26063006.repval(e,c)
end
function c26063006.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c26063006.repfilter,nil,e)
		e:SetLabel(count)
		return count>0 and e:GetHandler():CheckRemoveOverlayCard(tp,count,REASON_EFFECT)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c26063006.repop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	e:GetHandler():RemoveOverlayCard(tp,count,count,REASON_EFFECT)
end
function c26063006.ovmtg(e,c)
	return c==e:GetHandler()
end
function c26063006.thfilter1(c,g)
	return 
	(c:IsAbleToHand() and g:IsExists(c26063006.thfilter2,1,c,LOCATION_GRAVE)) or 
	(c:IsAbleToGrave() and g:IsExists(c26063006.thfilter2,1,c,LOCATION_HAND)) 
end
function c26063006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup()
	if chk==0 then return mg:IsExists(Card.IsAbleToHand,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and c:IsGeminiStatus() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
end
function c26063006.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup():Filter(Card.IsAbleToHand,nil)
	if c:IsRelateToEffect(e) and #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		if Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
			local tc=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end