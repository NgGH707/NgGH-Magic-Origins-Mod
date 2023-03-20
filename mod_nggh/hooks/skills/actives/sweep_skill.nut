::mods_hookExactClass("skills/actives/sweep_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Swing your mighty hand to the side, dealing damage to mutiple targets who are unlucky enough to get hit. May cause knock back.";
		this.m.Icon = "skills/active_112.png";
		this.m.IconDisabled = "skills/active_112_sw.png";
		this.m.Overlay = "active_112";
	};
	obj.getTooltip = function()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can hit up to 3 targets and never hit allies"
		});

		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Can [color=" + ::Const.UI.Color.NegativeValue + "]Knock Back[/color] on hit"
		});

		return ret;
	};
	obj.onTargetSelected <- function( _targetTile )
	{
		local ownTile = this.getContainer().getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		local nextDir = dir - 1 >= 0 ? dir - 1 : ::Const.Direction.COUNT - 1;

		if (ownTile.hasNextTile(nextDir))
		{
			local nextTile = ownTile.getNextTile(nextDir);

			if (::Math.abs(nextTile.Level - ownTile.Level) <= 1)
			{
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);
			}
		}

		nextDir = nextDir - 1 >= 0 ? nextDir - 1 : ::Const.Direction.COUNT - 1;

		if (ownTile.hasNextTile(nextDir))
		{
			local nextTile = ownTile.getNextTile(nextDir);

			if (::Math.abs(nextTile.Level - ownTile.Level) <= 1)
			{
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);
			}
		}
	};

	local ws_onUpdate = obj.onUpdate;
	obj.onUpdate = function( _properties )
	{
		ws_onUpdate(_properties);

		if (!::Nggh_MagicConcept.IsOPMode && this.getContainer().getActor().isPlayerControlled())
		{
			_properties.DamageRegularMax -= 10;
		}
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInFists ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	};
	obj.getMods <- function()
	{
		local ret = {
			Min = 0,
			Max = 0,
			HasTraining = false
		};
		local actor = this.getContainer().getActor();

		if (actor.getSkills().hasSkill("perk.legend_unarmed_training"))
		{
			local average = actor.getHitpoints() * 0.05;

			ret.Min += average;
			ret.Max += average;
			ret.HasTraining = true;
		}

		ret.Min = ::Math.max(0, ::Math.floor(ret.Min));
		ret.Max = ::Math.max(0, ::Math.floor(ret.Max));
		return ret;
	};
	obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill != this) return;

		local mods = this.getMods();
		_properties.DamageRegularMin += mods.Min;
		_properties.DamageRegularMax += mods.Max;

		if (mods.HasTraining)
		{
			_properties.DamageArmorMult += 0.1;
		}
	};
});