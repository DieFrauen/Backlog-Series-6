--Entrophys Projection
function c26065009.initial_effect(c)
	--summon tokens
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26065009,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26065009,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c26065009.cost)
	e1:SetTarget(c26065009.target1)
	e1:SetOperation(c26065009.activate1)
	c:RegisterEffect(e1)
	--Activate another Spell/Trap effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26065009,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,26065009,EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c26065009.cost)
	e2:SetTarget(c26065009.target2)
	e2:SetOperation(c26065009.activate2)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26065009,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,26065009,EFFECT_COUNT_CODE_OATH)
	e3:SetCost(c26065009.cost)
	e3:SetTarget(c26065009.target3)
	e3:SetOperation(c26065009.activate3)
	c:RegisterEffect(e3)
end
function c26065009.filter1(c,e)
	return c:IsAbleToDeckAsCost() and (
		   (c:IsCode(26065001) and c26065001.cansstk) or
		   (c:IsCode(26065002) and c26065002.cansstk) or
		   (c:IsCode(26065003) and c26065003.cansstk)  or
		   (c:IsCode(26067017) and c26067017.cansstk) )
end
function c26065009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c26065009.rescon1(sg,e,tp,mg)
	return (#sg)<=Duel.GetLocationCount(tp,LOCATION_MZONE)+sg:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD)
	and aux.dncheck
end
function c26065009.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(c26065009.filter1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return aux.SelectUnselectGroup(rg,e,tp,1,#rg,c26065009.rescon1,0)
		else return false end
	end
	e:SetLabel(0)
	local rsg=aux.SelectUnselectGroup(rg,e,tp,1,#rg,c26065009.rescon1,1,tp,HINTMSG_TODECK)
	Duel.ConfirmCards(1-tp,rsg)
	e:SetLabelObject(rsg)
	rsg:KeepAlive()
	Duel.SendtoDeck(rsg,nil,0,REASON_COST)
	Duel.ShuffleDeck(tp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c26065009.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local op,opt,tc=false,-2,nil
	tc=g:Select(tp,1,1,nil):GetFirst()
	while tc do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		if tc:GetOriginalCode()==26065001 then
			c26065001.spop(e,tp,eg,ep,ev,re,r,rp)
			g:RemoveCard(tc)
		end
		if tc:GetOriginalCode()==26065002 then
			c26065002.spop(e,tp,eg,ep,ev,re,r,rp)
			g:RemoveCard(tc)
		end
		if tc:GetOriginalCode()==26065003 then
			c26065003.spop(e,tp,eg,ep,ev,re,r,rp)
			g:RemoveCard(tc)
		end
		if tc:GetOriginalCode()==26067017 then
			c26067017.spop(e,tp,eg,ep,ev,re,r,rp)
			g:RemoveCard(tc)
		end
		tc=false
		if #g>0 then
			tc=g:Select(tp,0,1,nil):GetFirst()
		end
	end
end
function c26065009.filter2(c,e)
	return c:IsAbleToDeckAsCost() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c26065009.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(c26065009.filter2,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,c)
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return aux.SelectUnselectGroup(rg,e,tp,3,3,c26065009.rescon2,0)
		else return false end
	end
	local rsg=aux.SelectUnselectGroup(rg,e,tp,3,3,c26065009.rescon2,1,tp,HINTMSG_TODECK,c26065009.rescon2)
	Duel.ConfirmCards(1-tp,rsg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local sg=rsg:FilterSelect(tp,c26065009.filter2a,1,1,nil):GetFirst()
	local te,ceg,cep,cev,cre,cr,crp=sg:CheckActivateEffect(false,true,true)
	Duel.SendtoDeck(rsg,nil,0,REASON_COST)
	Duel.ShuffleDeck(tp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_CODE,1-tp,sg:GetCode())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	e:SetLabel(sg:GetCode())
	Duel.ClearOperationInfo(0)
end

function c26065009.rescon2(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,2,nil,0x665)
	and (#sg:Filter(Card.IsType,nil,TYPE_SPELL)==#sg or #sg:Filter(Card.IsType,nil,TYPE_TRAP)==#sg)
	and sg:IsExists(c26065009.filter2a,1,nil) and not sg:IsContains(e:GetHandler())
end
function c26065009.filter2a(c)
	return (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP) and c:CheckActivateEffect(false,true,true)~=nil
end
function c26065009.activate2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then
		Duel.Hint(HINT_CARD,1-tp,e:GetLabel())
		op(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c26065009.rescon3(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,1,nil,0x665)
	and #sg:Filter(Card.IsType,nil,TYPE_MONSTER)<2
	and #sg:Filter(Card.IsType,nil,TYPE_SPELL)<2
	and #sg:Filter(Card.IsType,nil,TYPE_TRAP)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<2
	and Duel.IsPlayerCanDraw(tp,#sg) and not sg:IsContains(e:GetHandler())
end
function c26065009.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return aux.SelectUnselectGroup(rg,e,tp,1,3,c26065009.rescon3,0)
		else return false end
	end
	e:SetLabel(0)
	local rsg=aux.SelectUnselectGroup(rg,e,tp,1,3,c26065009.rescon3,1,tp,HINTMSG_TODECK,c26065009.rescon3)
	Duel.ConfirmCards(1-tp,rsg)
	e:SetLabel(#rsg)
	Duel.SendtoDeck(rsg,nil,0,REASON_COST)
	Duel.ShuffleDeck(tp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c26065009.activate3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end