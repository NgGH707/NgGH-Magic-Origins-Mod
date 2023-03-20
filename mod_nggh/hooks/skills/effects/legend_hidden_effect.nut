::mods_hookExactClass("skills/effects/legend_hidden_effect", function(obj) 
{
	obj.onAdded = function()
	{
		local actor = this.getContainer().getActor();
		if (actor.getTile().IsVisibleForPlayer)
		{
			if (::Const.Tactical.HideParticles.len() != 0)
			{
				for( local i = 0; i < ::Const.Tactical.HideParticles.len(); i = ++i )
				{
					::Tactical.spawnParticleEffect(false, ::Const.Tactical.HideParticles[i].Brushes, actor.getTile(), ::Const.Tactical.HideParticles[i].Delay, ::Const.Tactical.HideParticles[i].Quantity, ::Const.Tactical.HideParticles[i].LifeTimeQuantity, ::Const.Tactical.HideParticles[i].SpawnRate, ::Const.Tactical.HideParticles[i].Stages);
				}
			}
		}

		actor.setBrushAlpha(10);

		if (actor.getFlags().has("human"))
		{
			actor.getSprite("hair").Visible = false;
			actor.getSprite("beard").Visible = false;
		}

		actor.setHidden(true);
		actor.setDirty(true);
	}
	obj.onUpdate = function( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor.getSkills().hasSkill("perk.legend_assassinate"))
		{
			_properties.DamageRegularMin *= 1.5;
			_properties.DamageRegularMax *= 1.5;

			if (actor.getSkills().hasSkill("background.legend_assassin") || actor.getSkills().hasSkill("background.assassin") || actor.getSkills().hasSkill("background.assassin_southern"))
			{
			_properties.DamageRegularMax *= 1.5;
			}
			if (actor.getSkills().hasSkill("bbackground.legend_commander_assassin"))
			{
			_properties.DamageRegularMax *= 2.0;
			}
		}

		_properties.TargetAttractionMult *= 0.5;
		actor.setBrushAlpha(10);
		
		if (actor.getFlags().has("human"))
		{
			actor.getSprite("hair").Visible = false;
			actor.getSprite("beard").Visible = false;
		}

		actor.setHidden(true);
		actor.setDirty(true);
	}
});