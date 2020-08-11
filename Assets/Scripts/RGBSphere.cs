using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RGBSphere : MonoBehaviour
{
    [SerializeField] private Renderer sphereRenderer;
    [SerializeField] private bool debug = true;
    [SerializeField] [Range(-2, 2)] private float debugSphereHeight = 0;
    [SerializeField] [Range(-360, 360)] private float debugSphereAngle = 0;

    private Vector3 crossSectionPoint = Vector3.zero;

    private void Update()
    {
        UpdateSphereRGB(false);
    }

    public void UpdateSphereRGB(bool editMode)
    {
        if (sphereRenderer != null)
        {
            if (editMode) sphereRenderer.sharedMaterial.SetVector("_CrossSectionPoint", crossSectionPoint);
            else sphereRenderer.material.SetVector("_CrossSectionPoint", crossSectionPoint);
        }
    }

    private void OnDrawGizmos()
    {
        if (debug)
        {
            Gizmos.color = Color.cyan;
            crossSectionPoint = GetDebugSpherePosition(out Vector3 direction);
            Gizmos.DrawSphere(crossSectionPoint, 0.1f);
            Gizmos.DrawRay(transform.position, direction);
        }
    }

    private Vector3 GetDebugSpherePosition(out Vector3 direction)
    {
        Vector3 rotatedVector = GetDebugSphereDistance() * transform.forward;
        rotatedVector = Quaternion.Euler(0, debugSphereAngle, 0) * rotatedVector;
        direction = rotatedVector + debugSphereHeight * Vector3.up;
        return transform.position + direction;
    }

    private float GetDebugSphereDistance()
    {
        return transform.localScale.x + 0.2f;
    }
}