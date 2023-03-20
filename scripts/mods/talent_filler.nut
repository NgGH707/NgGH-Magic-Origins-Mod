this.talent_filler <- {
	m = {
		ExcludedTalents = [],
		OtherTalentChances = [55, 35],
		PrimaryTalents = [],
		SecondaryTalents = [],

		StarsTotal = 0,
		StarsMax = 9,
		StarsMin = 0,
		UntalentedChance = 10,
		Chance = [45, 35, 20],
	},

	function clear()
	{
		this.m.ExcludedTalents = [];
		this.m.OtherTalentChances = [55, 35];
		this.m.PrimaryTalents = [];
		this.m.SecondaryTalents = [];
		this.m.StarsTotal = 0;
		this.m.StarsMax = 9;
		this.m.StarsMin = 0;
		this.m.Chance = [45, 35, 20];
	}
	
	function setExcludedTalents( _array )
	{
		this.m.ExcludedTalents = _array;
	}
	
	function setPrimaryTalents( _array )
	{
		this.m.PrimaryTalents = [];
		
		foreach ( att in _array )
		{
			if (this.m.ExcludedTalents.find(att) == null)
			{
				this.m.PrimaryTalents.push(att);
			}
		}
	}
	
	function setSecondaryTalents( _array )
	{
		this.m.SecondaryTalents = [];
		
		foreach ( att in _array )
		{
			if (this.m.ExcludedTalents.find(att) == null)
			{
				this.m.SecondaryTalents.push(att);
			}
		}
	}
	
	function setMaxStars( _num )
	{
		this.m.StarsMax = ::Math.min(::Math.abs(_num), (::Const.Attributes.COUNT - this.m.ExcludedTalents.len()) * 3)
		
		if (this.m.StarsMax < this.m.StarsMin)
		{
			this.m.StarsMin = this.m.StarsMax;
		}
	}
	
	function setMinStars( _num )
	{
		this.m.StarsMin = ::Math.min(this.m.StarsMax, ::Math.abs(_num));
	}

	function fillTalents( _possibleTalents, _bro)
	{
		local rolledTalentIndex = ::Math.rand(0, _possibleTalents.len() -1);
		local i = _possibleTalents[rolledTalentIndex];
		this.m.StarsTotal -= 1;

		if (++_bro.m.Talents[i] >= 3)
		{
			_bro.m.Talents[i] = 3;
			_possibleTalents.remove(rolledTalentIndex);
		}
	}

	function fillRemainingTalents( _bro )
	{
		if (this.m.ExcludedTalents.len() == 8)
		{
			return false;
		}

		local i = ::Math.rand(0, ::Const.Attributes.COUNT - 1);

		if (this.m.ExcludedTalents.find(i) == null && _bro.m.Talents[i] < 3)
		{
			this.m.StarsTotal -= 1;

			if (++_bro.m.Talents[i] >= 3)
			{
				_bro.m.Talents[i] = 3;
				this.m.ExcludedTalents.push(i);
			}

			return true;
		}

		return false;
	}

	function fillModdedTalentValues( _bro , _info = null , _stars = 0 , _isForce = false )
	{
		_bro.m.Talents = [];
		_bro.m.Talents.resize(::Const.Attributes.COUNT, 0);
		
		if (_info != null)
		{
			this.setExcludedTalents(_info.ExcludedTalents);
			this.setPrimaryTalents(_info.PrimaryTalents);
			this.setSecondaryTalents(_info.SecondaryTalents);
			this.setMaxStars(_info.StarsMax);
			this.setMinStars(_info.StarsMin);
		}

		if (!_isForce && (::Math.rand(1, 100) < this.m.UntalentedChance || (_bro.getBackground() != null && _bro.getBackground().isBackgroundType(::Const.BackgroundType.Untalented))))
		{
			return;
		}
		
		local numStarsToAdd = _stars != 0 ? _stars : ::Math.max(0, ::Math.rand(this.m.StarsMin, this.m.StarsMax) - ::Math.rand(0, 2));
		this.m.StarsTotal = numStarsToAdd;
		local noOtherTalents = this.m.PrimaryTalents.len() + this.m.SecondaryTalents.len() == this.Const.Attributes.COUNT - this.m.ExcludedTalents.len();
		local tries = 0;

		while (this.m.StarsTotal > 0 && tries < 50)
		{
			local r = ::Math.rand(1, 100);
			
			if (noOtherTalents)
			{
				if (this.m.PrimaryTalents.len() != 0 && r <= this.m.Chance[0])
				{
					this.fillTalents(this.m.PrimaryTalents, _bro);
					continue;
				}
				else if (this.m.SecondaryTalents.len() != 0)
				{
					this.fillTalents(this.m.SecondaryTalents, _bro);
					continue;
				}
				
				if (this.m.PrimaryTalents.len() == 0 && this.m.SecondaryTalents.len() == 0)
				{
					break;
				}
				
				++tries;
			}
			else
			{
				if (this.m.PrimaryTalents.len() != 0 && r <= this.m.Chance[0])
				{
					this.fillTalents(this.m.PrimaryTalents, _bro);
					continue;
				}
				else if (this.m.SecondaryTalents.len() != 0 && r <= this.m.Chance[0] + this.m.Chance[1])
				{
					this.fillTalents(this.m.SecondaryTalents, _bro);
					continue;
				}

				if (!this.fillRemainingTalents(_bro))
				{
					++tries;
				}
			}
		}

		this.clear();
	}
}