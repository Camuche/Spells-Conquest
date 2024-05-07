using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoulUpAndDown : MonoBehaviour
{
    float time, sin;
    public float speed, intensity;

    void Update()
    {
        time += Time.deltaTime;
        sin = Mathf.Sin(time / speed) * intensity;
        transform.position = new Vector3(transform.position.x, transform.position.y + sin, transform.position.z);
    }
}
