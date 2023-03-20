/*************************************************************************************
    World functions that help adding new charmed unit entries easily
*************************************************************************************/

local inWaitList = [];
local inOverwriteList = [];
local inOverwriteCustomList = [];

::nggh_addingValidEntries <- function( _array )
{
    if (!("CharmedUnits") in ::Const)
    {
        return ::logError("Fail to add new entries due to '::Const.CharmedUnits' don\'t exist");
    }

    if (!("CustomEntries") in ::Const.CharmedUnits)
    {
        ::Const.CharmedUnits.CustomEntries <- [];
    }

    if (typeof ::Const.CharmedUnits.CustomEntries != "array")
    {
        ::Const.CharmedUnits.CustomEntries = [];
    }

    ::Const.CharmedUnits.CustomEntries.extend(_array);
    ::Const.CharmedUnits.CustomEntries.sort(::nggh_sortingAscendingByType);
    ::logInfo("Successfully added " + _array.len() + " new entries");
    ::logDebug("---------------");
};

::nggh_addOrOverwriteThis <- function( _key , _inputTable , _targetTable )
{
    if (!_inputTable.rawin(_key))
    {
        return;
    }

    local value = ::nggh_deepCopy(_inputTable.rawget(_key));

    if (!_targetTable.rawin(_key))
    {
        _targetTable[_key] <- value;
    }
    else 
    {
        _targetTable[_key] = value;
    }

    ::logInfo("Overwriting '" + _key + "'");
};

::nggh_overwriteEntries <- function()
{
    if (inOverwriteList.len() == 0 && inOverwriteCustomList.len() == 0)
    {
        return;
    }

    ::logInfo("Overwriting charmed unit entries.....");
    ::logInfo("--------------------");
    local keywords = [
        "Icon",
        "StatMod",
        "Perks",
        "Difficulty",
        "Custom",
        "PerkTree",
        "Script",
        "Background",
        "Requirements",
        "IsExperienced",
    ];
    local count = 0;

    foreach (i, entry in inOverwriteList )
    {
        ::logInfo((i + 1) + ". " + entry.ID);
        local find = ::Const.CharmedUnits.Data[entry.Type];

        foreach ( key in keywords )
        {
            ::nggh_addOrOverwriteThis(key, entry, find);
        }

        ++count;
    }

    foreach (i, entry in inOverwriteCustomList )
    {
        ::logInfo((count + i + 1) + ". " + entry.ID);
        local index = ::nggh_findThisInArray(entry.Type, ::Const.CharmedUnits.CustomEntries, "Type");

        if (index == null)
        {
            ::logError("Error - Can't find an existed entry of " + entry.ID + " to overwrite");
            continue;
        }

        local find = ::Const.CharmedUnits.CustomEntries[index];

        foreach ( key in keywords )
        {
            ::nggh_addOrOverwriteThis(key, entry, find);
        }
    }

    ::logInfo("Finishing overwrite entries.....");
    ::logDebug("---------------");
    inOverwriteList.clear();
    inOverwriteCustomList.clear();
};

::nggh_processingEntries <- function()
{
    if (inWaitList.len() == 0)
    {
        return;
    }

    ::logDebug("--------------------");
    ::logInfo("Processing new charmed unit entries.....");
    ::logInfo("--------------------");

    local pretext = "scripts/entity/tactical/";
    local scripts = ::IO.enumerateFiles(pretext);
    local pretextBG = "scripts/skills/backgrounds/";
    local backgrounds = ::IO.enumerateFiles(pretextBG);
    local valid = [];
    local discarded = [];

    foreach (i, entry in inWaitList )
    {
        ::logInfo((i + 1) + ". " + entry.ID);
        local isHuman = !entry.rawin("Background") && !entry.rawin("Script");
        local isValid = true;

        if (isHuman)
        {
            ::logInfo("Is considered to be a human entry");
        }
        else
        {
            if (entry.rawin("Background") && backgrounds.find(pretextBG + entry.Background) == null)
            {
                ::logError("Invalid Entry - Background file from 'Background' doesn't exist");
                isValid = false;
            }
            
            if (entry.rawin("Script") && scripts.find(pretext + entry.Script) == null)
            {
                ::logError("Invalid Entry - Entity script file from 'Script' doesn't exist");
                isValid = false;
            }
        }

        if (!isHuman && !entry.rawin("Requirements"))
        {
            ::logError("Invalid Entry - Is missing 'Requirements'");
            isValid = false;
        }

        if (!entry.rawin("PerkTree"))
        {
            ::logError("Invalid Entry - Is missing 'PerkTree'");
            isValid = false;

            if (isHuman)
            {
                ::logError("Please add 'PerkTree' with a human background file name");
            }
            else
            {
                ::logError("Please add 'PerkTree' with a perk tree, check !mods_preload/mod_nggh_hexen_origin_new_perk_defs for reference");
            }
        }

        if (!isHuman)
        {
            if (!entry.rawin("Custom"))
            {
                ::logError("Invalid Entry - Is missing 'Custom'");
                isValid = false;
            }
            else
            {
                if (!entry.Custom.rawin("BgModifiers"))
                {
                    ::logError("Invalid Entry - Is missing 'BgModifiers' in 'Custom'");
                    isValid = false;
                }

                if (!entry.Custom.rawin("Talents"))
                {
                    ::logError("Invalid Entry - Is missing 'Talents' in 'Custom'");
                    isValid = false;
                }
            }
        }

        if (isValid)
        {
            ::logInfo("Accepting.....");
            valid.push(entry);
        }
        else 
        {
            ::logError("Discarding.....");
            discarded.push(entry);
        }

        ::logInfo("--------------------");
    }

    if (discarded.len() != 0)
    {
        ::logInfo("Total discarded entries: " + discarded.len());
    }

    ::logInfo("Total valid entries: " + valid.len());

    if (valid.len() == 0)
    {
        ::logInfo("No entry can be added.....");
        ::logDebug("--------------------");
        return;
    }

    ::logInfo("Adding valid entries.....");
    ::nggh_addingValidEntries(valid);
    inWaitList.clear();
};

::nggh_registerCharmedEntries <- function ( _array )
{
    if (typeof _array != "array")
    {
        ::logError("Invalid Input Array - Not an array")
        return;
    }

    local a = [];
    local b = [];
    local c = [];
    ::logDebug("--------------------");
    ::logInfo("Proceeding to quick check applied entries...");
    //removing duplicated entry and quick check for valid
    foreach (i, table in _array )
    {
        if (typeof table != "table")
        {
            ::logError("Invalid Entry - Entry must be defined as a table");
            continue;
        }

        if (!table.rawin("ID"))
        {
            ::logError("Invalid Entry - Is missing 'ID' to identify this entry name");
            continue;
        }

        if (!table.rawin("Type"))
        {
            ::logError("Invalid Entry - Is missing 'Type'");
            continue;
        }

        if (table.rawget("Type") <= ::Const.CharmedUnits.Data.len() - 1)
        {
            b.push(table);
            continue;
        }

        local input = [];
        input.extend(a);
        input.extend(inWaitList);

        if (::nggh_hasThisInArray(table.Type, input, "Type"))
        {
            c.push(table);
            continue;
        }

        a.push(table);
    }

    if (a.len() == 0 && b.len() == 0 && c.len() == 0)
    {
        ::logError("All entries are invalid");
        return 
    }

    inWaitList.extend(a);
    inWaitList.sort(::nggh_sortingAscendingByType);
    inOverwriteList.extend(b);
    inOverwriteList.sort(::nggh_sortingAscendingByType);
    inOverwriteCustomList.extend(c);
    inOverwriteCustomList.sort(::nggh_sortingAscendingByType);
};


/*************************************************************************************
    A library contains simple world functions that seem to be useful for my mod
*************************************************************************************/


//Check if tables in an array has a specific key value equal to a certain value
::nggh_hasThisInArray <- function( _value, _array, _key)
{
    foreach ( table in _array ) 
    {
        if (typeof table != "table" || !table.rawin(_key))
        {
            continue;
        }

        if (table.rawget(_key) == _value)
        {
            return true;
        }
    }

    return false;
};
::nggh_findThisInArray <- function( _value, _array, _key )
{
    foreach (i, table in _array ) 
    {
        if (typeof table != "table" || !table.rawin(_key))
        {
            continue;
        }

        if (table.rawget(_key) == _value)
        {
            return i;
        }
    }

    return null;
};


::nggh_sortingAscendingByType <- function( _a, _b )
{
    if (_a.Type < _b.Type)
    {
        return -1;
    }
    else if (_a.Type > _b.Type)
    {
        return 1;
    }

    return 0;
};
::nggh_sortingDescendingByType <- function( _a, _b )
{
    if (_a.Type < _b.Type)
    {
        return 1;
    }
    else if (_a.Type > _b.Type)
    {
        return -1;
    }

    return 0;
};


//deep copy table/array, work better than "clone" keyword
::nggh_deepCopy <- function( _container ) 
{ 
    // Container must not have circular references 
    switch (typeof _container) 
    {
    case "table": 
        local result = clone _container; 
        foreach(k ,v in _container) 
        {
        	result[k] = ::nggh_deepCopy(v);
        }
        return result; 

    case "array": 
        return _container.map(::nggh_deepCopy);

    default: 
        return _container;
    }
};

