::mods_hookExactClass("skills/actives/gore_skill", function ( obj )
{
	obj.m.IsPlayer <- false;

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Dealing devastating damage by ramming with an incredible speed, easily punch through enemy formation.";
		this.m.KilledString = "Crushed";
		this.m.Icon = "skills/active_166.png";
		this.m.IconDisabled = "skills/active_166_sw.png";
		this.m.IsAOE = true;
	};
	obj.onAdded <- function()
	{
		if (this.getContainer().getActor().isPlayerControlled())
		{
			this.m.IsVisibleTileNeeded = true;
			this.m.IsIgnoringRiposte = true;
			this.m.IsPlayer = true;
			this.m.ActionPointCost = 4;
			this.m.MinRange = 1;
			this.m.MaxRange = 6;
			this.m.ChanceDisembowel = 30;
			this.m.ChanceSmash = 30;
		};

		this.getContainer().add(::new("scripts/skills/actives/nggh_mod_gore_skill_zoc"));
	};
	obj.getTooltip <- function()
	{
		local ret = this.skill.getDefaultTooltip();

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/stat_screen_dmg_dealt.png",
				text = "Always inflicts at least [color=" + ::Const.UI.Color.DamageValue + "]" + 15 + "[/color] damage to hitpoints, regardless of armor"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range within [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMinRange() + "[/color] - [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can [color=" + ::Const.UI.Color.PositiveValue + "]Stagger[/color] and [color=" + ::Const.UI.Color.PositiveValue + "]Knock Back[/color] on a hit"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can hit up to 5 targets"
			},
		]);

		return ret;
	};
	obj.onUpdate = function( _properties )
	{
		_properties.DamageMinimum += 15;
		_properties.DamageRegularMin += 100;
		_properties.DamageRegularMax += 130;
		_properties.DamageArmorMult *= 0.75;

		if (::Tactical.isActive() && this.getContainer().getActor().isPlacedOnMap() && ::Time.getRound() == 1)
		{
			this.m.MaxRange = 10;
		}
		else
		{
			this.m.MaxRange = 6;
		}
	};
	obj.applyEffectToTarget = function( _user, _target, _targetTile )
	{
		if (_target.isNonCombatant())
		{
			return;
		}

		_target.getSkills().add(::new("scripts/skills/effects/staggered_effect"));

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " has staggered " + ::Const.UI.getColorizedEntityName(_target) + " for one turn");
		}

		if (!_target.getCurrentProperties().IsRooted)
		{
			local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

			if (knockToTile == null)
			{
				return;
			}

			this.m.TilesUsed.push(knockToTile.ID);

			if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " has knocked back " + ::Const.UI.getColorizedEntityName(_target));
			}

			local skills = _target.getSkills();
			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");
			skills.removeByID("effects.legend_vala_chant_disharmony_effect");
			skills.removeByID("effects.legend_vala_chant_fury_effect");
			skills.removeByID("effects.legend_vala_chant_senses_effect");
			skills.removeByID("effects.legend_vala_currently_chanting");
			skills.removeByID("effects.legend_vala_in_trance");
			_target.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
			local damage = ::Math.max(0, ::Math.abs(knockToTile.Level - _targetTile.Level) - 1) * ::Const.Combat.FallingDamage;

			if (damage == 0)
			{
				::Tactical.getNavigator().teleport(_target, knockToTile, null, null, true);
			}
			else
			{
				local p = this.getContainer().getActor().getCurrentProperties();
				local tag = {
					Attacker = _user,
					Skill = this,
					HitInfo = clone ::Const.Tactical.HitInfo
				};
				tag.HitInfo.DamageRegular = damage;
				tag.HitInfo.DamageDirect = 1.0;
				tag.HitInfo.BodyPart = ::Const.BodyPart.Body;
				tag.HitInfo.BodyDamageMult = 1.0;
				tag.HitInfo.FatalityChanceMult = 1.0;
				::Tactical.getNavigator().teleport(_target, knockToTile, this.onKnockedDown, tag, true);
			}
		}
	};
	obj.onTargetSelected <- function( _targetTile )
	{
		local ownTile = _targetTile;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ownTile.getNextTile(i);

				if (::Math.abs(tile.Level - ownTile.Level) <= 1)
				{
					::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
				}
			}
		}
	}
});