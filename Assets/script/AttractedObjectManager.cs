using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttractedObjectManager : MonoBehaviour
{
    public static AttractedObjectManager instance;

    void Awake()
    {
        instance = this;
    }
}
