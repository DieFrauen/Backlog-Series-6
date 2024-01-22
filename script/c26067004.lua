--The Desceptim Marchosia
function c26067004.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--place in opponent deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_PZONE)
	e1:SetLabel(0)
	e1:SetCountLimit(1,26067004)
	e1:SetCondition(c26067004.decon)
	e1:SetTarget(c26067004.detg)
	e1:SetOperation(c26067004.deop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_TO_GRAVE)
	e1a:SetLabel(1)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1b:SetLabel(2)
	c:RegisterEffect(e1b)
	local e1c=e1:Clone()
	e1c:SetLabel(3)
	e1c:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1c)
	local e1d=e1:Clone()
	e1d:SetLabel(4)
	e1d:SetRange(LOCATION_HAND)
	e1d:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e1d)
	local e1e=e1:Clone()
	e1e:SetLabel(5)
	e1e:SetRange(LOCATION_HAND)
	e1e:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1e)
	--when drawn effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26067004,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetLabel(0)
	e2:SetTarget(c26067004.sptg)
	e2:SetOperation(c26067004.spop)
	e2:SetCondition(c26067004.spcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	--e4:SetCountLimit(1,{26067004,1})
	e4:SetCondition(c26067004.condition)
	e4:SetTarget(c26067004.target)
	e4:SetOperation(c26067004.activate)
	c:RegisterEffect(e4)
end
function c26067004.cfilter(c,e,tp,opp)
	local lab=e:GetLabel()
	if lab>2 then lab=lab-3 end
	return opp and
	(
	(lab==0 and not c:IsReason(REASON_DRAW)) or
	lab==1 or
	(c:IsSummonPlayer(tp) and lab==2)
	)
	and c:IsPreviousLocation(LOCATION_DECK)  
end
function c26067004.decon(e,tp,eg,ep,ev,re,r,rp)
	local opp=rp~=tp
	return eg:IsExists(c26067004.cfilter,1,nil,e,1-tp,opp) 
end
function c26067004.defilter(c) 
	return not c:IsForbidden() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667)
end
function c26067004.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26067004.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()>2 and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)==0 then return end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(c26067004.defilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
	local g2=Duel.GetMatchingGroup(c26067004.defilter,tp,LOCATION_DECK,0,1,nil)
	if Duel.IsPlayerAffectedByEffect(tp,26067010) then
		g:Merge(g2)
	end
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 then return end
	local sc=sg:GetFirst()
	if Duel.SendtoDeck(sc,1-tp,0,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_DECK) then
		sc:ReverseInDeck()
		sc:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD &~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
		if #g>0 and Duel.CheckPendulumZones(tp) and sg:GetFirst()==e:GetHandler() and Duel.SelectYesNo(tp,aux.Stringid(26067004,2)) then
			local sc=g2:Select(tp,1,1,nil):GetFirst()
			Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c26067004.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(26067001)>0 or e:GetType()&EFFECT_TYPE_TRIGGER_O ~=0
end
function c26067004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26067004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=c:GetOwner()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,op,op,false,false,POS_FACEUP)
	end
end
function c26067004.pcon(e)
	local p=e:GetHandlerPlayer()
	if e:GetLabel()==1 then p=1-p end
	local tc=Duel.GetDecktopGroup(p,1):GetFirst()
	return tc and tc:IsSetCard(0x667) and tc:IsFaceup()
end
function c26067004.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) or c:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c26067004.dkfilter(c,tp) 
	return c:IsSetCard(0x667) and c:GetOwner()==tp
end
function c26067004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067004.filter,tp,LOCATION_DECK,LOCATION_DECK,1,nil,tp) end
end
function c26067004.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26067004,0))
	local p=e:GetHandlerPlayer()
	local g1=Duel.GetMatchingGroup(c26067004.dkfilter,tp,LOCATION_DECK,0,nil,p)
	local g2=Duel.GetMatchingGroup(c26067004.dkfilter,tp,0,LOCATION_DECK,nil,p)
	local ops,opval,off={},{},1
	if #g1>0 then
		ops[off]=aux.Stringid(26067004,3)
		opval[off-1]=1
		off=off+1
	end
	if #g2>0 then
		ops[off]=aux.Stringid(26067004,4)
		opval[off-1]=2
		off=off+1
	end
	if #g1>0 and #g2>0 then
		ops[off]=aux.Stringid(26067004,5)
		opval[off-1]=3
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26067004,6))
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if op==nil then return end
	if opval[op]~=2 then
		local tc1=g1:Select(tp,1,1,nil):GetFirst()
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc1,0)
		Duel.ConfirmDecktop(tp,1)
		tc1:ReverseInDeck()
		tc1:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD&~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
	end
	if opval[op]~=1 then
	   local tc2=g2:Select(tp,1,1,nil):GetFirst()
		Duel.ShuffleDeck(1-tp)
		Duel.MoveSequence(tc2,0)
		Duel.ConfirmDecktop(1-tp,1)
		tc2:ReverseInDeck()
		tc2:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD&~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
	end
end