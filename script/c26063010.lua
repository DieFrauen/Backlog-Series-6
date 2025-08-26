--Astelloy Smelting
function c26063010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26063010,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26063010)
	e1:SetCost(c26063010.cost)
	e1:SetTarget(c26063010.target)
	e1:SetOperation(c26063010.activate)
	c:RegisterEffect(e1)
	--salvage materials
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c26063010.remtcon)
	e5:SetOperation(c26063010.remtop)
	c:RegisterEffect(e5)
end
c26063010.listed_names={26063001}
function c26063010.costfilter(c,tp)
	return c:IsDiscardable() and not c:IsPublic() and
	c:IsType(TYPE_NORMAL) and 
	((c:IsCode(26063001) and Duel.IsPlayerCanDraw(tp,2)) or
	Duel.IsPlayerCanDraw(tp,2))
end
function c26063010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(2)
	if chk==0 then return Duel.IsExistingMatchingCard(c26063010.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c26063010.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	e:SetLabelObject(tc)
	if tc:IsCode(26063001) then e:SetLabel(3) end
	Duel.ShuffleHand(tp)
end
function c26063010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lb=e:GetLabel()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,lb)
end
function c26063010.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)==0 then return end
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end
function c26063010.ovfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x663)
end
function c26063010.remtfilter(c)
	local ovg=c:GetOverlayGroup()
	return c:IsType(TYPE_XYZ) and ovg:FilterCount(c26063010.ovfilter,nil)>0 and #ovg>0
end
function c26063010.remtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg and eg:IsExists(c26063010.remtfilter,1,nil) then
		for tc in eg:Iter() do
			if tc:GetOverlayGroup():IsExists(c26063010.ovfilter,1,nil) then return true end
		end
	end
	return false
end
function c26063010.remtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,26063010)
	local mtg=Group.CreateGroup()
	local tg=eg:Filter(c26063010.remtfilter,nil)
	for tc in eg:Iter() do
		if tc:IsType(TYPE_XYZ) and tc:GetFlagEffect(26063010)==0 then
			mtg:Merge(tc:GetOverlayGroup():Filter(c26063010.ovfilter,nil))
			tc:RegisterFlagEffect(26063010,RESET_CHAIN,0,1)
		end
	end
	local ct=math.min(#mtg,#g)
	if #mtg>0 and Duel.GetFlagEffect(tp,26063010)==0 and Duel.SelectYesNo(tp,aux.Stringid(26063010,ct)) then
		mtc=mtg:Select(tp,1,ct,nil)
		if #mtc>0 then
			Duel.HintSelection(Group.FromCards(e:GetHandler()))
			Duel.Hint(HINT_CARD,tp,26063010)
			Duel.SendtoHand(mtc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,mtc)
			Duel.RegisterFlagEffect(tp,26063010,0,0,1)
		end
	end
end