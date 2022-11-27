--The Desceptim Marshal - Bael
function c26066007.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--destroy and create pendulum scales
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26066007.detg)
	e1:SetOperation(c26066007.deop)
	c:RegisterEffect(e1)
	--Send cards to the graveyard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26066007,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26066007.sgtg)
	e3:SetOperation(c26066007.sgop)
	--c:RegisterEffect(e3)
end

function c26066007.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,LOCATION_PZONE)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c26066007.pcfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden() and not c:IsCode(26066007)
end
function c26066007.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	local pg=Duel.GetMatchingGroup(c26066007.pcfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	if #pg>0 and Duel.SelectYesNo(tp,aux.Stringid(26066007,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		tc=pg:Select(tp,1,2,nil)
		local pg=tc:GetFirst()
		for pg in aux.Next(tc) do
			Duel.MoveToField(pg,tp,tp,LOCATION_PZONE,POS_FACEUP,false)
			pg:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
	end
end



function c26066007.damfilter(c,p)
	return c:GetOwner()==p and c:IsAbleToGrave()
end
function c26066007.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0xff,0)
	if chk==0 then return g:IsExists(Card.IsCode,1,nil,26066001)
	and g:IsExists(Card.IsCode,1,nil,26066002)
	and g:IsExists(Card.IsCode,1,nil,26066003)
	and g:IsExists(Card.IsCode,1,nil,26066004)
	and g:IsExists(Card.IsCode,1,nil,26066005)
	and g:IsExists(Card.IsCode,1,nil,26066006) end
	local g=Duel.GetFieldGroup(tp,0xff,0)
	local dc=g:FilterCount(c26066007.damfilter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c26066007.sgfilter(c,p)
	return c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() and c:IsControler(p)
end
function c26066007.sgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=nil
	local g=Duel.GetFieldGroup(tp,0xff,0):Filter(Card.IsType,nil,TYPE_MONSTER)
	g:KeepAlive()
	local sp=Group.FromCards(c)
	Duel.HintSelection(sp)
	Duel.Remove(sp,POS_FACEUP,REASON_EFFECT)
	sp=g:FilterSelect(tp,Card.IsCode,1,1,nil,26066001)
	Duel.HintSelection(sp)
	Duel.Remove(sp,POS_FACEUP,REASON_EFFECT)
	sp=g:FilterSelect(tp,Card.IsCode,1,1,nil,26066002)
	Duel.HintSelection(sp)
	Duel.Remove(sp,POS_FACEUP,REASON_EFFECT)
	sp=g:FilterSelect(tp,Card.IsCode,1,1,nil,26066003)
	Duel.HintSelection(sp)
	Duel.Remove(sp,POS_FACEUP,REASON_EFFECT)
	sp=g:FilterSelect(tp,Card.IsCode,1,1,nil,26066004)
	Duel.HintSelection(sp)
	Duel.Remove(sp,POS_FACEUP,REASON_EFFECT)
	sp=g:FilterSelect(tp,Card.IsCode,1,1,nil,26066005)
	Duel.HintSelection(sp)
	Duel.Remove(sp,POS_FACEUP,REASON_EFFECT)
	sp=g:FilterSelect(tp,Card.IsCode,1,1,nil,26066006)
	Duel.HintSelection(sp)
	Duel.Remove(sp,POS_FACEUP,REASON_EFFECT)
	Duel.HintSelection(sp)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local ct=#g
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*100,REASON_EFFECT)
	end
end