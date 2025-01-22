::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/charmed_effect", function(q) 
{
	q.m.IsSuicide <- false;
	/*
	obj.m.IsBodyguard <- false;
	obj.m.IsTheLastEnemy <- false;
	
	obj.isTheLastEnemy <- function( _v )
	{
		this.m.IsTheLastEnemy = _v;
	};
	*/
	q.getName <- function()
	{
		return m.TurnsLeft == 0 ? m.Name : format("%s (%i %s left)", m.Name, m.TurnsLeft, m.TurnsLeft > 1 ? "turns" : "turn");
	}

	/*
	local ws_onAdded = obj.onAdded;
	obj.onAdded = function()
	{
		local actor = this.getContainer().getActor();
		local brush = "bust_base_beasts";

		if (actor.getAIAgent().getBehavior(::Const.AI.Behavior.ID.Protect) != null)
		{
			this.m.IsBodyguard = true;
			actor.getAIAgent().removeBehavior(::Const.AI.Behavior.ID.Protect);
		}

		ws_onAdded();

		if (this.m.Master != null && this.m.Master.getContainer() != null && this.m.Master.getContainer().getActor() != null)
		{
			brush = this.m.Master.getContainer().getActor().getSprite("socket").getBrush().Name;
		}

		if (!this.m.IsTheLastEnemy)
		{
			actor.getSprite("socket").setBrush(brush);
			actor.getFlags().set("Charmed", true);
			
			if (!actor.getFlags().has("human"))
			{
				this.onFactionChanged();
			}
			
			actor.setDirty(true);
		}
		else
		{
			actor.killSilently();
		}
	};

	local ws_onRemoved = obj.onRemoved;
	obj.onRemoved = function()
	{
		if (this.m.IsSuicide)
		{
			return;
		}

		local actor = this.getContainer().getActor();
		ws_onRemoved();

		if (this.m.IsBodyguard)
		{
			actor.getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/ai_protect"));
		}

		if (!actor.getFlags().has("human"))
		{
			this.onFactionChanged();
			actor.setDirty(true);
		}
	};
	*/

	q.onSuicide <- function()
	{
		m.IsSuicide = true;
		getContainer().getActor().kill(null, null, ::Const.FatalityType.Suicide);
	}

});