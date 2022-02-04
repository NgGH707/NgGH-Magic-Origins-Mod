this.getroottable().Nggh_MagicConcept.hookAccessoryDog <- function ()
{
	// allow enemy to spawn dog on death
	::mods_hookDescendants("items/accessory/accessory_dog", function(obj) 
	{
	    if (::mods_getRegisteredMod("mod_AC") != null)
	    {
	    	obj.onActorDied = function(_onTile)
			{
				if (this.m.Type != null && !this.isUnleashed() && _onTile != null && this.getScript() != null && this.Const.Companions.Library[this.m.Type].Unleash.onActorDied)
				{
					local actor = this.getContainer().getActor();
					local faction = actor.getFaction();
					local isPlayer = faction == this.Const.Faction.Player;
					local entity = this.Tactical.spawnEntity(this.getScript(), _onTile.Coords.X, _onTile.Coords.Y);
					entity.setItem(this);
					entity.setName(this.getName());
					entity.setVariant(this.getVariant());
					entity.setFaction(isPlayer ? this.Const.Faction.PlayerAnimals : faction);

					if (!isPlayer && actor.hasSprite("socket"))
					{
						entity.getSprite("socket").setBrush(actor.getSprite("socket").getBrush().Name);
					}

					entity.applyCompanionScaling();
					this.setEntity(entity);

					if (this.getArmorScript() != null)
					{
						local item = this.new(this.getArmorScript());
						entity.getItems().equip(item);
					}

					if (!this.World.getTime().IsDaytime)
					{
						entity.getSkills().add(this.new("scripts/skills/special/night_effect"));
					}

					local healthPercentage = (100.0 - this.m.Wounds) / 100.0;
					entity.setHitpoints(this.Math.max(1, this.Math.floor(healthPercentage * entity.m.Hitpoints)));
					entity.setDirty(true);
					this.Sound.play(this.m.UnleashSounds[this.Math.rand(0, this.m.UnleashSounds.len() - 1)], this.Const.Sound.Volume.Skill, _onTile.Pos);
				}
			}
	    }
	    else
	    {
	    	obj.onActorDied <- function( _onTile )
			{
				if (!this.isUnleashed() && _onTile != null)
				{
					local actor = this.getContainer().getActor();
					local faction = actor.getFaction();
					local isPlayer = faction == this.Const.Faction.Player;
					local entity = this.Tactical.spawnEntity(this.getScript(), _onTile.Coords.X, _onTile.Coords.Y);
					entity.setItem(this);
					entity.setName(this.getName());
					entity.setVariant(this.getVariant());
					if (this.getContainer().getActor().getSkills().hasSkill("perk.legend_dogwhisperer"))
					{
						entity.getSkills().add(this.new("scripts/skills/perks/perk_fortified_mind"));
						entity.getSkills().add(this.new("scripts/skills/perks/perk_colossus"));
						entity.getSkills().add(this.new("scripts/skills/perks/perk_underdog"));
					}

					this.setEntity(entity);
					entity.setFaction(isPlayer? this.Const.Faction.PlayerAnimals : faction);

					if (!isPlayer && actor.hasSprite("socket"))
					{
						entity.getSprite("socket").setBrush(actor.getSprite("socket").getBrush().Name);
					}

					if (this.m.ArmorScript != null)
					{
						local item = this.new(this.m.ArmorScript);
						entity.getItems().equip(item);
					}

					this.Sound.play(this.m.UnleashSounds[this.Math.rand(0, this.m.UnleashSounds.len() - 1)], this.Const.Sound.Volume.Skill, _onTile.Pos);
				}
			}
	    }
	});

	delete this.Nggh_MagicConcept.hookAccessoryDog;
}