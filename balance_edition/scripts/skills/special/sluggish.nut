this.sluggish <- this.inherit("scripts/skills/skill", {
	m = {
		Limit = 20,
		IsDisableFleetfooted = false,
	},
	function create()
	{
		this.m.ID = "special.sluggish";
		this.m.Name = "Weighed Down";
		this.m.Icon = "skills/status_effect_53.png";
		this.m.IconMini = "status_effect_53_mini";
		this.m.Overlay = "status_effect_111";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.Special;
		this.m.IsActive = false;
		this.m.IsSerialized = false;
	}

	function getDescription()
	{
		return "Ahhh! This is too heavy, this character has a hard time with this heavy set of armor.";
	}
	
	function getTooltip()
	{
		local fat = this.getModifier();
		local tooltip = [
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
		];

		if (fat > 0)
		{
			local fm = this.Math.floor((this.Math.maxf(1.0, 1.05 + this.Math.pow(fat, 1.23) * 0.01) * 100) - 100);
			local mm = this.Math.floor(fat / 8);
			
			tooltip.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = "Has [color=" + this.Const.UI.Color.NegativeValue + "]+" + fm + "%[/color] effect of Fatigue To Initiative"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = "Builds up [color=" + this.Const.UI.Color.NegativeValue + "]" + fm + "%[/color] more fatigue for each tile travelled"
				},
			]);
			
			if (fat >= 8)
			{
				tooltip.extend([
					{
						id = 6,
						type = "text",
						icon = "ui/icons/tracking_disabled.png",
						text = "Costs [color=" + this.Const.UI.Color.NegativeValue + "]" + mm + "[/color] more Action Point for each tile travelled"
					},
				]);
			}
			
			if (fat >= 12)
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Can not be targeted by [color=" + this.Const.UI.Color.NegativeValue + "]Rotation[/color] skill"
				});
			}
			
			if (fat >= 16)
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Costs [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] more Action Point when using skill"
				});
			}
		}

		return tooltip;
	}
	
	function isHidden()
	{
		return this.getModifier() == 0;
	}
	
	function onUpdate( _properties )
	{
		local fat = this.getModifier();
		
		if (fat == 0)
		{
			return;
		}
		
		_properties.FatigueToInitiativeRate *= this.Math.maxf(1.0, 1.05 + this.Math.pow(fat, 1.23) * 0.01);
		_properties.MovementFatigueCostMult *= this.Math.maxf(1.0, 1.05 + this.Math.pow(fat, 1.23) * 0.01);
		this.m.IsDisableFleetfooted = fat >= 8;

		if (fat >= 8)
		{
			_properties.MovementAPCostAdditional += this.Math.floor(fat / 8);
		}
		
		if (fat >= 12)
		{
			_properties.IsImmuneToRotation = true;
		}
		
		if (fat >= 16)
		{
			_properties.AdditionalActionPointCost += 1;
		}
	}

	function onAfterUpdate( _properties )
	{
		if (this.m.IsDisableFleetfooted)
		{
			_properties.IsFleetfooted = false;
		}
	}
	
	function getModifier()
	{
		local fat = 0;
		local body = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local head = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);

		if (body != null)
		{
			fat = fat + body.getStaminaModifier();
		}

		if (head != null)
		{
			fat = fat + head.getStaminaModifier();
		}

		fat = this.Math.min(0, fat + this.m.Limit);

		if (fat > 0)
		{
			return 0;
		}
		
		return this.Math.abs(fat);
	}

});

