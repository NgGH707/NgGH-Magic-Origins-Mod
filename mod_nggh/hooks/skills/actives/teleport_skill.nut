::mods_hookExactClass("skills/actives/teleport_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Teleport away by using unknown power at the same time causes the surrounding temperature to drop down absolute zero. ";
		this.m.Icon = "skills/active_167.png";
		this.m.IconDisabled = "skills/active_167_sw.png";
		this.m.Overlay = "active_167";
	};
	obj.onAdded <- function()
	{
		if (this.getContainer().getActor().isPlayerControlled())
		{
			this.m.IsVisibleTileNeeded = true;
			this.m.ActionPointCost = 4;
			this.m.MinRange = 1;
			this.m.MaxRange = 15;
		}
	};
	obj.onUpdate <- function( _properties )
	{
		_properties.Vision += 7;
	};
	obj.getTooltip = function()
	{
		local p = this.getContainer().getActor().getCurrentProperties();
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of  [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Creates snow tiles and causes chilled effect to anyone nearby"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Teleport instantly"
			},
		];
	};

	local ws_onUse = obj.onUse;
	obj.onUse = function( _user, _targetTile )
	{
		if (_user.getCurrentProperties().IsRooted)
		{
			::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(_user) + " is free from ensnared");

			if (this.m.SoundOnHit.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), ::Const.Sound.Volume.Skill, _targetTile.Pos);
			}

			_user.getSprite("status_rooted").Visible = false;
			_user.getSprite("status_rooted_back").Visible = false;
			
			local free = _user.getEntity().getSkills().getSkillByID("actives.break_free");
			
			if (free != null)
			{
				if (free.m.Decal != "")
				{
					local ourTile = this.getContainer().getActor().getTile();
					local candidates = [];

					if (ourTile.Properties.has("IsItemSpawned") || ourTile.IsCorpseSpawned)
					{
						for( local i = 0; i < ::Const.Direction.COUNT; i = ++i )
						{
							if (!ourTile.hasNextTile(i))
							{
							}
							else
							{
								local tile = ourTile.getNextTile(i);

								if (tile.IsEmpty && !tile.Properties.has("IsItemSpawned") && !tile.IsCorpseSpawned && tile.Level <= ourTile.Level + 1)
								{
									candidates.push(tile);
								}
							}
						}
					}
					else
					{
						candidates.push(ourTile);
					}

					if (candidates.len() != 0)
					{
						local tileToSpawnAt = ::MSU.Array.rand(candidates);
						tileToSpawnAt.spawnDetail(free.m.Decal);
						tileToSpawnAt.Properties.add("IsItemSpawned");
					}
				}
			}

			_user.setDirty(true);
			this.getContainer().removeByID("effects.net");
			this.getContainer().removeByID("effects.rooted");
			this.getContainer().removeByID("effects.web");
			this.getContainer().removeByID("effects.kraken_ensnare");
			this.getContainer().removeByID("effects.serpent_ensnare");
			this.getContainer().removeByID("actives.break_free");
		}

		return ws_onUse(_user, _targetTile);
	};
});