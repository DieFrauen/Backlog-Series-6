--Fulmiknight Celestial Vault
function c26061007.initial_effect(c)
	c:EnableCounterPermit(0x661)
	c:SetCounterLimit(0x661,5)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetLabel(0)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(26061007,0))
	e2:SetLabel(1)
	e2:SetTarget(c26061007.target)
	c:RegisterEffect(e2)
	--trigger while on field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26061007,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+26061007)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c26061007.target)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_FZONE)
	--e4:SetCondition(c26061007.regcon)
	e4:SetOperation(c26061007.regop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_PAY_LPCOST)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_RECOVER)
	c:RegisterEffect(e6)
	--you died
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EVENT_LEAVE_FIELD_P)
	e7:SetOperation(c26061007.leaveop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetLabelObject(e7)
	e8:SetOperation(c26061007.leave)
	c:RegisterEffect(e8)
end
c26061007.listed_names={26061008}
function c26061007.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(26061007)==0
end
function c26061007.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ev>0 and ep==tp then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+26061007,e,0,tp,tp,0)
		c:RegisterFlagEffect(26061007,RESET_CHAIN,0,1)
	end
end
function c26061007.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x661)
	if ct then
		e:SetLabel(ct)
	else e:SetLabel(0) end
end
function c26061007.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel()
	if ct and c:IsPreviousControler(tp) then
		Duel.Damage(tp,ct*2000,REASON_EFFECT)
	end
end
function c26061007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local e1=c26061007.rectg
	local e2=c26061007.tgtg
	local e3=c26061007.thtg
	local e4=c26061007.tftg
	local p1=e1(e,tp,eg,ep,ev,re,r,rp,0)
	local p2=e2(e,tp,eg,ep,ev,re,r,rp,0)
	local p3=e3(e,tp,eg,ep,ev,re,r,rp,0) and c26061007.cost(e,tp,0,3)
	local p4=e4(e,tp,eg,ep,ev,re,r,rp,0) and c26061007.cost(e,tp,0,5)
	if chk==0 then return p1 or p2 or p3 or p4 end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELECT)
	local op=Duel.SelectEffect(tp,
		{p1,aux.Stringid(26061007,1)},
		{p2,aux.Stringid(26061007,2)},
		{p3,aux.Stringid(26061007,3)},
		{p4,aux.Stringid(26061007,4)})
	if op==1 then
		e1(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c26061007.recop)
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_COUNTER)
	end
	if op==2 then
		e2(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c26061007.tgop)
		e:SetCategory(CATEGORY_TOGRAVE)
	end
	if op==3 then
		c26061007.cost(e,tp,1,3)
		e3(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c26061007.thop)
		e:SetCategory(CATEGORY_TOHAND)
	end
	if op==4 then
		c26061007.cost(e,tp,1,5)
		e4(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c26061007.tfop)
		e:SetCategory(0)
	end
end
function c26061007.filter(c)
	return c:IsSetCard(0x661) and c:IsAbleToGrave()
end
function c26061007.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLP(tp)+1000<Duel.GetLP(1-tp) and c:GetCounter(0x661)<5 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,0,tp,1)
end
function c26061007.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=1
	local lp,op=Duel.GetLP(tp),Duel.GetLP(1-tp)
	if lp+1000<op then
		local t={}
		while c:IsCanAddCounter(0x661,ct) and lp+(ct*1000)<=op do
			t[ct]=ct
			ct=ct+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26061007,5))
		local count=Duel.AnnounceNumber(tp,table.unpack(t))
		c:AddCounter(0x661,count)
		Duel.Recover(tp,count*1000,REASON_EFFECT)
	end
end
function c26061007.cost(e,tp,chk,ct)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x661,ct,REASON_COST) end
	c:RemoveCounter(tp,0x661,ct,REASON_COST)
end
function c26061007.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCodel)==#sg
end
function c26061007.tgfilter(c)
	return c:IsSetCard(0x661) and c:IsAbleToGrave()
end
function c26061007.scfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c26061007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetCounter(0x661)
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26061007.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x661)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	local dg=Duel.GetDecktopGroup(tp,ct)
	Duel.ConfirmDecktop(tp,#dg)
	local sg=dg:Filter(c26061007.tgfilter,nil)
	if #sg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.DisableShuffleCheck()
		if Duel.SendtoGrave(sc,REASON_EFFECT)~=0 then 
			dg=Duel.GetDecktopGroup(tp,ct-1)
			if #dg==0 then return end
		end
	end
	if Duel.SelectYesNo(tp,aux.Stringid(26042008,6)) then
		if #dg>1 then 
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26042008,7))
			Duel.SortDecktop(tp,tp,#dg)
		end
	else
		Duel.MoveToDeckBottom(dg,p)
		if #dg>1 then 
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26042008,7))
			Duel.SortDeckbottom(tp,tp,#dg)
		end
	end
end
function c26061007.thfilter(c,tp)
	local lpv=c:GetAttack()+c:GetDefense()
	return c:IsSetCard(0x661) and c:IsMonster() and c:IsAbleToHand()
end
function c26061007.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c26061007.thfilter() end
	local g=Duel.GetMatchingGroup(c26061007.thfilter,tp,LOCATION_GRAVE,0,nil,tp,lp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c26061007.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26061007.thfilter),tp,LOCATION_GRAVE,0,nil,tp)
	local sc=g:Select(tp,1,1,nil)
	if #sc>0 then
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
	end
end
function c26061007.tffilter(c,tp)
	return c:IsCode(26061008) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26061007.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26061007.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c26061007.tfop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26061007.tffilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	local tc=0
	if #tg==tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK) then
		tc=tg:GetFirst()
	else
		tc=tg:Select(tp,1,1,nil):GetFirst()
	end
	Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
end