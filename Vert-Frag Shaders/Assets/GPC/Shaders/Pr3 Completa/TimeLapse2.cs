using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeLapse2 : MonoBehaviour
{
    public float minValue = -0.5f;
    public float maxValue = 0.5f;
    public float velocity = 0.5f;
    public float currentValue = 0;
    public string shaderVariableName = "_Altura";

    // Update is called once per frame
    void Update()
    {
        currentValue += velocity * Time.deltaTime;

        float inRangeValue = minValue + Mathf.PingPong(currentValue, (maxValue - minValue));
        GetComponent<MeshRenderer>().sharedMaterial.SetFloat(shaderVariableName, inRangeValue);
    }
}
