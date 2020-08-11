using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(RGBSphere))]
[CanEditMultipleObjects]
public class RGBSphereEditor : Editor
{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        (target as RGBSphere).UpdateSphereRGB(true);
    }
}
