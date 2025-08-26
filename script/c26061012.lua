--Fulmiknight Decisive Strike
function c26061012.initial_effect(c)
	--Fusion
	local e1=Fusion.CreateSummonEff({handler=c,fusfilter=aux.FilterBoolFunction(Card.IsType,TYPE_UNION),matfilter=nil,extrafil=c26061012.fextra,extraop=nil,stage2=c26061012.sstage2,desc=aux.Stringid(26061012,0),extratg=nil})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_RECOVER)
	c:RegisterEffect(e1)
	if not c26061012.global_check then
		c26061012.global_check=true
		c26061012[0]=0
		c26061012[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c26061012.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c26061012.clearop)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_DAMAGE_CALCULATING)
		Duel.RegisterEffect(ge3,0)
	end
	--Set itself from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26061012,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,26061012,EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c26061012.setcon)
	e2:SetTarget(c26061012.settg)
	e2:SetOperation(c26061012.setop)
	c:RegisterEffect(e2)
end
function c26061012.maxfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsFaceup()
end

function c26061012.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c26061012.maxfilter,0,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c26061012.maxfilter,1,LOCATION_MZONE,0,nil)
	local v1,v2=0,0
	if #g1>0 then
		v1=g1:GetMaxGroup(Card.GetAttack):GetFirst():GetAttack()
	end
	if #g2>0 then
		v2=g2:GetMaxGroup(Card.GetAttack):GetFirst():GetAttack()
	end
	if v1>c26061012[0] then
		c26061012[0]=v1
	end
	if v2>c26061012[1] then
		c26061012[1]=v2
	end
end
function c26061012.clearop(e,tp,eg,ep,ev,re,r,rp)
	c26061012[0]=0
	c26061012[1]=0
end
function c26061012.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(c26061012.fxfilter,tp,LOCATION_SZONE,0,nil)
end
function c26061012.fxfilter(c,e,tp)
	return c:IsType(TYPE_UNION) and c:IsFaceup() and c:GetEquipTarget() and c:IsAbleToGrave()
end
function c26061012.sstage2(e,tc,tp,sg,chk)
	local op1,op2,op=Duel.GetLP(tp)~=8000,Duel.GetLP(1-tp)~=8000,0
	if chk==1 and (op1 or op2) and Duel.SelectYesNo(tp,aux.Stringid(26061012,6)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26061012,2))
		if op1 and op2 then
			op=Duel.SelectOption(tp,aux.Stringid(26061012,3),aux.Stringid(26061012,4),aux.Stringid(26061012,5))
		elseif op1 then
			op=Duel.SelectOption(tp,aux.Stringid(26061012,3))
			op=0
		elseif op2 then
			Duel.SelectOption(tp,aux.Stringid(26061012,4))
			op=1
		end
		if op~=1 then Duel.SetLP(tp,8000) end
		if op~=0 then Duel.SetLP(1-tp,8000) end
	end
end
function c26061012.atfilter(c,tp)
	local val=math.min(Duel.GetLP(tp),3000)
	return c:IsFaceup() and c:IsAttackAbove(3000)
end
function c26061012.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
	and Duel.IsMainPhase()
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	and Duel.IsExistingMatchingCard(c26061012.atfilter,tp,0,LOCATION_MZONE,1,nil,tp)
end
function c26061012.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26061012.filter(chkc) end
	if chk==0 then return c:IsSSetable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c26061012.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c,tp,false) then
		Duel.ConfirmCards(1-tp,c)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e0:SetReset(RESET_PHASE+PHASE_END)
		c:RegisterEffect(e0)
		--activate cost
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_CHAIN_ACTIVATING)
		e1:SetCondition(c26061012.costchk)
		e1:SetOperation(c26061012.costop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		Duel.RegisterEffect(e1,tp)
	end
end
function c26061012.costchk(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetLabelObject() 
end
function c26061012.costop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
	e1:SetDescription(aux.Stringid(26061012,8))
	e1:SetCondition(c26061012.damcon)
	e1:SetOperation(c26061012.damop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_CARD,tp,26061012)
end
function c26061012.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c26061012.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,26061012)
	Duel.Damage(tp,c26061012[tp],REASON_EFFECT)
end