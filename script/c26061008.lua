--Fulmiknight Siege
function c26061008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PAY_LPCOST)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c26061008.drcon)
	e2:SetOperation(c26061008.drop)
	c:RegisterEffect(e2)
	--Double damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c26061008.rdcon)
	e3:SetOperation(c26061008.rdop)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26061008,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetTarget(c26061008.lptg)
	e4:SetOperation(c26061008.lpop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(26061007)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(1,1)
	c:RegisterEffect(e5)
end
function c26061008.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ev>=2000
end
function c26061008.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,26061008)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c26061008.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local ac,dc=Duel.GetAttacker(),Duel.GetAttackTarget()
	if not dc then return end
	local val=1
	local lpv=math.abs(Duel.GetLP(ep)-Duel.GetLP(1-ep))
	local eqc=ac:GetEquipGroup():FilterCount(Card.IsType,nil,TYPE_UNION)+dc:GetEquipGroup():FilterCount(Card.IsType,nil,TYPE_UNION)+2
	while (ev*val)<lpv and eqc>1 do
		val=val*2
		eqc=eqc-2
	end
	e:SetLabel(val)
	return ev>0
end
function c26061008.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*e:GetLabel())
	Duel.Hint(HINT_CARD,tp,26061008)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+26061008,e,REASON_EFFECT,tp,ep,ev*2)
end
function c26061008.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,ep,ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-ep,ev)
end
function c26061008.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(ep,ev,REASON_EFFECT)
	Duel.Recover(1-ep,ev,REASON_EFFECT)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end