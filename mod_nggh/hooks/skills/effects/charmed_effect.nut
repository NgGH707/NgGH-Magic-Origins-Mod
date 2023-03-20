::mods_hookExactClass("skills/effects/charmed_effect", function(obj) 
{
	/*
	obj.m.IsBodyguard <- false;
	obj.m.IsTheLastEnemy <- false;
	obj.m.IsSuicide <- false;

	obj.isTheLastEnemy <- function( _v )
	{
		this.m.IsTheLastEnemy = _v;
	};
	*/
	obj.getName <- function()
	{
		if (this.m.TurnsLeft == 0)
		{
			return this.m.Name;
		}
		
		return this.m.Name + " (" + this.m.TurnsLeft + " turns left)";
	};

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
	obj.onSuicide <- function()
	{
		this.m.IsSuicide = true;
		actor.kill(null, null, ::Const.FatalityType.Suicide);
	};
});