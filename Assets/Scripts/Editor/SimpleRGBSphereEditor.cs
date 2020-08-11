using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(SimpleRGBSphere))]
[CanEditMultipleObjects]
public class SimpleRGBSphereEditor : Editor
{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        (target as SimpleRGBSphere).UpdateColor(true);
        (target as SimpleRGBSphere).UpdatePhysicalProperties();
    }
}
