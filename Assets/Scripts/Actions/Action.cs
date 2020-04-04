using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Action : UnityData
{
    public abstract void Perform();
    public abstract void Revert();
}