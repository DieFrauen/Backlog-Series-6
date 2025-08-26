--Fulmiknight Devotion
function c26061010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetDescription(aux.Stringid(26061010,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(1000)
	e1:SetCountLimit(1,26061010,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26061010.target)
	e1:SetOperation(c26061010.activate)
	c:RegisterEffect(e1)
	aux.GlobalCheck(c26061010,function()
		c26061010[0]=0
		c26061010[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(c26061010.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			c26061010[0]=0
			c26061010[1]=0
		end)
	end)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26061010,4))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{26061010,1})
	e2:SetCondition(c26061010.retcon)
	e2:SetTarget(c26061010.rettg)
	e2:SetOperation(c26061010.retop)
	c:RegisterEffect(e2)
end
function c26061010.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==Duel.GetTurnPlayer() then
		local val=ev
		c26061010[ep]=c26061010[ep]+val
	end
end
function c26061010.ffilter(c,tp)
	return c:IsFieldSpell()
	and c:IsSetCard(0x661)
	and (
	c:GetActivateEffect():IsActivatable(tp,true,true) or
	c:IsSSetable())
end
function c26061010.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER)
	and c:IsSetCard(0x661)
	and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c26061010.tgfilter(c,e,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and Duel.IsExistingMatchingCard(c26061010.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c,tp)
end
function c26061010.eqfilter(c,ec,tp)
	return c:IsType(TYPE_UNION)
	and c:CheckUnionTarget(ec)
	and aux.CheckUnionEquip(c,ec)
	and not Duel.IsExistingMatchingCard(c26061010.snfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c26061010.snfilter(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function c26061010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c26061010.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	local p1=#g1>0 and Duel.GetFieldCard(tp,LOCATION_FZONE,0)==nil
	local g2=Duel.GetMatchingGroup(c26061010.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local p2=#g2>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
	local p3=Duel.IsExistingMatchingCard(c26061010.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if chk==0 then return (p1 or p2 or p3) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c26061010.activate(e,tp,eg,ep,ev,re,r,rp)
	local lab=c26061010[tp]
	local lc=lab
	local g1=Duel.GetMatchingGroup(c26061010.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	local g2=Duel.GetMatchingGroup(c26061010.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local g3=Duel.GetMatchingGroup(c26061010.tgfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	local b1,b2,b3=
	#g1>0 and Duel.GetFieldCard(tp,LOCATION_FZONE,0)==nil,
	#g2>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0,
	#g3==1
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(26061010,0))
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26061010,0)},
		{b2,aux.Stringid(26061010,1)},
		{b3,aux.Stringid(26061010,2)})
	if op==1 then 
		if c26061010.effect1(e,tp,g1) and lc>=2000 and Duel.SelectYesNo(tp,aux.Stringid(26061010,3)) then
			lc=lc-2000 
			op=Duel.SelectEffect(tp,{false,nil},
			{b2,aux.Stringid(26061010,1)},
			{b3,aux.Stringid(26061010,2)})
		else return end
	end
	if op==2 then 
		if c26061010.effect2(e,tp,g2) and lc>=2000
		and Duel.SelectYesNo(tp,aux.Stringid(26061010,2)) then
			lc=lc-2000 
			op=3
		else return end
	end
	if op==3 then 
		g3=Duel.GetMatchingGroup(c26061010.tgfilter,tp,LOCATION_MZONE,0,nil,e,tp)
		c26061010.effect3(e,tp,g3)
	end
end
function c26061010.effect1(e,tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	if g and Duel.GetFieldGroupCount(tp,LOCATION_FZONE,0)==0 then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if Duel.SSet(tp,tc,true)~=0 then
			return true
		else return false end
	end
	return false
end
function c26061010.effect2(e,tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if #g>0 then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then return true else return false end
	end
	return false
end
function c26061010.effect3(e,tp,g)
	if #g==1 then
		local tc=g:GetFirst()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then
		   Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT) 
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26061010.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc,tp):GetFirst()
		if sc and aux.CheckUnionEquip(sc,tc) and Duel.Equip(tp,sc,tc) then aux.SetUnionState(sc)
		else return false end
	end
	return false
end

function c26061010.retcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c26061010.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE|PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c26061010.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	_replace_count=_replace_count+1
	if _replace_count<=_replace_max and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetOperation(c26061010.dmgop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c26061010.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local val=3000-c26061010[tp]
	if val>0 then Duel.Damage(tp,val,REASON_EFFECT) end
end