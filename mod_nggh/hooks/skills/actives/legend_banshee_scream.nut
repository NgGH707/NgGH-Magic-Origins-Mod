::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_banshee_scream", function(q) 
{
	/*
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.IsMagicSkill = true;
		this.m.MagicPointsCost = 5;
	};
	*/
	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
		});
		return ret;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local ret = __original(_user, _targetTile);

		// make champion geist more dangerous with their scream
		if (_user.getSkills().hasSkill("racial.champion")) {
			_targetTile.getEntity().checkMorale(-1,  -5, ::Const.MoraleCheckType.MentalAttack);
			_targetTile.getEntity().checkMorale(-1, -10, ::Const.MoraleCheckType.MentalAttack);
			_targetTile.getEntity().checkMorale(-1, -10, ::Const.MoraleCheckType.MentalAttack);
			_targetTile.getEntity().getSkills().add(::new("scripts/skills/effects/nggh_mod_ghost_debuff_effect"));

			// AoE around the target lol
			applyAoEMoraleEffect(_user, _targetTile);

			// AoE around the user lmao
			applyAoEMoraleEffect(_user, _user.getTile());
		}
		
		return ret;
	}

	q.applyAoEMoraleEffect <- function( _user, _originTile )
	{
		for( local i = 0; i != 6; ++i )
		{
			if (!_originTile.hasNextTile(i))
				continue;

			local tile = _originTile.getNextTile(i);

			if (::Math.abs(_originTile.Level - tile.Level) > 1)
				continue;

			if (!tile.IsOccupiedByActor || tile.getEntity().isAlliedWith(_user))
				continue;

			tile.getEntity().checkMorale(-1,  -5, ::Const.MoraleCheckType.MentalAttack);
			tile.getEntity().checkMorale(-1, -10, ::Const.MoraleCheckType.MentalAttack);
			tile.getEntity().checkMorale(-1, -10, ::Const.MoraleCheckType.MentalAttack);
		}
	}

});