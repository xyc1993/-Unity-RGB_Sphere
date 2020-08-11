using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleRGBSphere : MonoBehaviour
{
    [SerializeField] private  Renderer sphereRenderer;
    [SerializeField] private bool updatePhysicalProperties = true;
    [SerializeField] [Range(0, 1)] private float radiusOffset = 1.0f;
    [Header("Red - Radius")]
    [SerializeField] [Range(0, 1)] private float r = 1.0f;
    [Header("Green - Phi")]
    [SerializeField] [Range(-180, 180)] private float g = 0.0f;
    [Header("Blue - Theta")]
    [SerializeField] [Range(-90, 90)] private float b = 0.0f;

    private void Update()
    {
        UpdateColor(false);
        UpdatePhysicalProperties();
    }

    public void UpdateColor(bool editMode)
    {
        if (sphereRenderer != null)
        {
            Color sphericalColor = GetSphericalColor();
            if (editMode) sphereRenderer.sharedMaterial.color = sphericalColor;
            else sphereRenderer.material.color = sphericalColor;
        }
    }

    private Color GetSphericalColor()
    {
        float r = this.r;
        float g = Mathf.Lerp(0.0f, 1.0f, (this.g + 180.0f) / 360.0f);
        float b = Mathf.Lerp(0.0f, 1.0f, (this.b + 90.0f) / 180.0f);
        return new Color(r, g, b, 1.0f);
    }

    public void UpdatePhysicalProperties()
    {
        if (!updatePhysicalProperties) return;
        if (sphereRenderer != null)
        {
            sphereRenderer.transform.localScale = (r + radiusOffset) * Vector3.one;
            sphereRenderer.transform.rotation = Quaternion.Euler(b, g, 0.0f);
        }
    }
}