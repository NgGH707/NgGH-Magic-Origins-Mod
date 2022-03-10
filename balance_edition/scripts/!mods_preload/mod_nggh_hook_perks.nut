this.getroottable().Nggh_MagicConcept.hookPerks <- function ()
{
	//
	::mods_hookExactClass("skills/perks/perk_nine_lives", function(obj) 
	{
		obj.m.NineLivesCount <- 1;

		obj.isSpent = function()
		{
			return this.m.NineLivesCount <= 0;
		};
		obj.restoreLife <- function()
		{
			if (this.getMaxLives() > this.m.NineLivesCount) this.addNineLivesCount();
		};
		obj.addNineLivesCount <- function( _n = 1 )
		{
			this.m.LastFrameUsed = 0;
			this.m.NineLivesCount = this.Math.min(8, this.m.NineLivesCount + _n);
		};
		obj.getMaxLives <- function()
		{
			return this.getContainer().getActor().getFlags().getAsInt("max_lives");
		}
		obj.getName <- function()
		{
			local ret = this.skill.getName();

			if (this.m.NineLivesCount == 1)
			{
				return ret + " (" + (this.m.NineLivesCount) + " life left)"
			}
			else if (this.m.NineLivesCount > 1)
			{
				return ret + " (" + (this.m.NineLivesCount) + " lives left)"
			}

			return ret;
		};
		obj.setSpent = function(_f)
		{
			if (_f && !this.isSpent())
			{
				this.getContainer().add(this.new("scripts/skills/effects/nine_lives_effect"));

				if (--this.m.NineLivesCount == 0)
				{
					local rune = this.getContainer().getSkillByID("special.legend_RSA_diehard");
					if (rune != null) rune.activate();
					this.m.LastFrameUsed = this.Time.getFrame();
				}

				this.getContainer().removeByType(this.Const.SkillType.DamageOverTime);
			}
		}
		obj.isHidden <- function()
		{
			return this.isSpent();
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/health.png",
					text = "Extra life left: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.NineLivesCount + "[/color]"
				}
			];
		};
		local ws_create = obj.create;
		obj.create <- function()
		{
			ws_create();
			this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
			this.m.IconMini = "perk_07_mini";
			this.m.Overlay = "perk_07";
		};
		obj.onUpdate = function( _properties )
		{
			if (this.isSpent() && this.m.LastFrameUsed == this.Time.getFrame())
			{
				this.getContainer().removeByType(this.Const.SkillType.DamageOverTime);
			}

			_properties.SurviveWithInjuryChanceMult *= 1.11;
		};
		obj.onCombatFinished = function()
		{
			this.m.NineLivesCount = this.Math.max(1, this.m.NineLivesCount);
			this.m.LastFrameUsed = 0;
			this.skill.onCombatFinished();
		};
		obj.onSerialize <- function( _out )
		{
			this.skill.onSerialize(_out);
			_out.writeI8(this.m.NineLivesCount);
		};
		obj.onDeserialize <- function( _in )
		{
			this.skill.onDeserialize(_in);
			this.m.NineLivesCount = _in.readI8();
		};
	});


	//
	::mods_hookExactClass("skills/perks/perk_overwhelm", function(obj) 
	{
		local ws_onTargetHit = obj.onTargetHit;
		obj.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
			if (_targetEntity != null && _targetEntity.getCurrentProperties().IsImmuneToOverwhelm)
			{
				return;
			}

			ws_onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		};
	});


	//
	::mods_hookExactClass("skills/perks/perk_pathfinder", function(obj) 
	{
		obj.m.IsGhost <- false;
		obj.m.CanMount <- false;
		obj.onAdded <- function()
		{
			this.m.IsGhost = this.isKindOf(this.getContainer().getActor().get(), "ghost_player");
			this.m.CanMount = "isMounted" in this.getContainer().getActor().get();
		};
		obj.onUpdate = function( _properties )
		{
			local actor = this.getContainer().getActor();

			if (this.m.CanMount && actor.isMounted())
			{
				actor.m.LevelActionPointCost = 0;
				actor.m.LevelFatigueCost = 2;
			}
			else
			{
				if (!this.m.IsGhost)
				{
					actor.m.ActionPointCosts = this.Const.PathfinderMovementAPCost;
				}
				
				actor.m.FatigueCosts = clone this.Const.PathfinderMovementFatigueCost;
				actor.m.LevelFatigueCost = this.Const.Movement.LevelDifferenceFatigueCost;
				actor.m.LevelActionPointCost = 0;
			}
		}
	});


	//Change to work with mounting system of goblin
	::mods_hookExactClass("skills/perks/perk_horse_liberty", function(obj) 
	{
	    obj.onUpdate <- function( _properties )
	    {
	        if (this.getContainer().getActor().isMounted())
	        {
	        	_properties.MovementFatigueCostMult *= 0.75;
	        	_properties.BraveryMult *= 1.25;
	        }
	    }
	});

	delete this.Nggh_MagicConcept.hookPerks;
}