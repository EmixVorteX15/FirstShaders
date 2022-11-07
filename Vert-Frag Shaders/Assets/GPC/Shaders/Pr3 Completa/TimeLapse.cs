using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeLapse : MonoBehaviour
{
    public float minValue = 0.0f;
    public float maxValue = 1.0f;
    public float velocity = 0.5f;
    public float currentValue = 0;
    public string shaderVariableName = "Custom/Disipacion";

    // Update is called once per frame
    void Update()
    {
        currentValue += velocity * Time.deltaTime;

        float inRangeValue = minValue + Mathf.PingPong(currentValue, (maxValue - minValue));
        GetComponent<MeshRenderer>().sharedMaterial.SetFloat(shaderVariableName, inRangeValue);
    }
}
