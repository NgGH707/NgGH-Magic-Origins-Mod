this.getroottable().HexenHooks.hookPTR <- function ()
{
	local AutoEnableForBeasts = function(_skill)
	{
		local actor = _skill.getContainer().getActor().get();

		if (this.isKindOf(actor, "player_beast") || this.isKindOf(actor, "minion"))
		{
			_skill.m.IsForceEnabled = true;
		}
	};
	::mods_hookExactClass("skills/effects/ptr_whack_a_smack_effect", function ( obj )
	{
		obj.m.IsForceEnabled <- false;
		obj.onAdded <- function()
		{
			AutoEnableForBeasts(this);
		};
		obj.isInEffect <- function()
		{
			local actor = this.getContainer().getActor();
			if (!actor.hasZoneOfControl())
			{
				return false;
			}

			if (this.m.IsForceEnabled)
			{
				return true;
			}

			local weapon = actor.getMainhandItem();
			if (weapon == null || !weapon.isWeaponType(this.Const.Items.WeaponType.Staff))
			{
				return false;
			}

			return true;
		};
	});
	::mods_hookExactClass("skills/perks/perk_ptr_light_weapon", function ( obj )
	{
		obj.onAdded <- function()
		{
			AutoEnableForBeasts(this);
		};
	});
	::mods_hookExactClass("skills/perks/perk_ptr_between_the_ribs", function ( obj )
	{
		obj.onAdded <- function()
		{
			AutoEnableForBeasts(this);
		};
	});
	::mods_hookExactClass("skills/perks/perk_ptr_versatile_weapon", function ( obj )
	{
		obj.m.IsForceEnabled <- false;
		obj.onAdded <- function()
		{
			AutoEnableForBeasts(this);
		};
		obj.onUpdate <- function( _properties )
		{
			if (!this.m.IsForceEnabled)
			{
				local weapon = this.getContainer().getActor().getMainhandItem();

				if (weapon == null || !weapon.isWeaponType(this.Const.Items.WeaponType.Sword))
				{
					return;
				}
			}

			_properties.MeleeDamageMult += this.m.Bonus;
			_properties.DamageDirectAdd += this.m.Bonus;
			_properties.DamageArmorMult += this.m.Bonus;
		}
	});
	::mods_hookExactClass("skills/perks/perk_ptr_cull", function ( obj )
	{
		obj.onAdded <- function()
		{
			AutoEnableForBeasts(this);
		};
	});
	::mods_hookExactClass("skills/perks/perk_ptr_utilitarian", function ( obj )
	{
		obj.onAdded <- function()
		{
			AutoEnableForBeasts(this);
		};
	});
	::mods_hookExactClass("skills/perks/perk_ptr_heavy_strikes", function ( obj )
	{
		obj.m.IsForceEnabled <- false;
		obj.onAdded <- function()
		{
			AutoEnableForBeasts(this);
		};
		obj.onTargetHit <- function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
			local actor = this.getContainer().getActor();

			if (!_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(actor))
			{
				return;
			}

			if (_skill == null || _skill.isAttack() || !_skill.hasDamageType(this.Const.Damage.DamageType.Blunt))
			{
				return;
			}

			if (!this.m.IsForceEnabled)
			{
				local weapon = actor.getMainhandItem();

				if (weapon == null || !weapon.isWeaponType(this.Const.Items.WeaponType.Mace))
				{
					return;
				}
			}

			_targetEntity.getSkills().add(this.new("scripts/skills/effects/legend_baffled_effect"));
		};
	});
	::mods_hookExactClass("skills/perks/perk_ptr_dismantle", function ( obj )
	{
		obj.onAdded <- function()
		{
			AutoEnableForBeasts(this);
		}
	});
	::mods_hookExactClass("skills/perks/perk_ptr_deadly_precision", function ( obj )
	{
		obj.m.IsForceEnabled <- false;
		obj.onAdded <- function()
		{
			AutoEnableForBeasts(this);
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			local weapon = this.getContainer().getActor().getMainhandItem();
			
			if (this.m.IsForceEnabled || (weapon != null && weapon.isWeaponType(this.Const.Items.WeaponType.Flail)))
			{
				_properties.DamageDirectAdd += 0.01 * (_targetEntity == null ? this.m.MaxBonus : this.Math.rand(this.m.MinBonus, this.m.MaxBonus)); 
			}
		};
	});
	::mods_hookExactClass("skills/perks/perk_ptr_from_all_sides", function ( obj )
	{
		obj.onAdded <- function()
		{
			AutoEnableForBeasts(this);
		};
	});
	::mods_hookExactClass("skills/perks/perk_ptr_mauler", function ( obj )
	{
		obj.onAdded <- function()
		{
			AutoEnableForBeasts(this);
		};
	});
	::mods_hookExactClass("skills/actives/ptr_between_the_eyes_skill", function ( obj )
	{
		obj.isHidden <- function()
		{
			if (this.getContainer().getActor().getFlags().has("human"))
			{
				return !this.getContainer().getActor().isArmedWithMeleeWeapon();
			}

			return this.m.IsHidden;
		};
	});

	delete this.HexenHooks.hookPTR;
}